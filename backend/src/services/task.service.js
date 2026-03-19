const prisma = require('../lib/prisma');
const AppError = require('../utils/app-error');
const {
  serializeLocation,
  serializePagination,
  serializeVolunteerSummary,
} = require('../utils/serializers');
const {
  parsePositiveInteger,
  validateTaskAssignmentCreatePayload,
  validateTaskAssignmentUpdatePayload,
  validateTaskCreatePayload,
  validateTaskListQuery,
  validateTaskUpdatePayload,
} = require('../validators/resource.validators');
const { resolveLocationInput } = require('./location.service');

const volunteerSummarySelect = {
  id: true,
  fullName: true,
  nationalId: true,
  email: true,
  phone: true,
  status: true,
};

function formatDateOnly(value) {
  return value ? new Date(value).toISOString().slice(0, 10) : null;
}

function formatTimeOnly(value) {
  return value ? new Date(value).toISOString().slice(11, 19) : null;
}

function serializeAssignment(assignment) {
  return {
    id: assignment.id,
    volunteerId: assignment.volunteerId,
    taskId: assignment.taskId,
    status: assignment.status,
    checkInTime: assignment.checkInTime?.toISOString() ?? null,
    checkOutTime: assignment.checkOutTime?.toISOString() ?? null,
    hoursWorked: assignment.hoursWorked,
    volunteer: serializeVolunteerSummary(assignment.volunteer),
  };
}

function buildTaskInclude(options = {}) {
  const include = {
    location: true,
    campaign: {
      select: {
        id: true,
        title: true,
        status: true,
        createdById: true,
      },
    },
    _count: {
      select: {
        volunteerTasks: true,
        reports: true,
      },
    },
  };

  if (options.currentVolunteerId) {
    include.volunteerTasks = {
      where: {
        volunteerId: options.currentVolunteerId,
      },
    };
  }

  if (options.includeAssignments) {
    include.volunteerTasks = {
      include: {
        volunteer: {
          select: volunteerSummarySelect,
        },
      },
      orderBy: {
        id: 'asc',
      },
    };
  }

  return include;
}

function serializeTask(task, options = {}) {
  const includeAssignments = options.includeAssignments ?? false;
  const currentVolunteerId = options.currentVolunteerId ?? null;
  const assignments = Array.isArray(task.volunteerTasks) ? task.volunteerTasks : [];
  const myAssignment =
    currentVolunteerId !== null
      ? assignments.find((assignment) => assignment.volunteerId === currentVolunteerId) || null
      : null;

  return {
    id: task.id,
    title: task.title,
    description: task.description,
    date: formatDateOnly(task.date),
    startTime: formatTimeOnly(task.startTime),
    endTime: formatTimeOnly(task.endTime),
    status: task.status,
    campaign: task.campaign
      ? {
          id: task.campaign.id,
          title: task.campaign.title,
          status: task.campaign.status,
          createdById: task.campaign.createdById,
        }
      : null,
    location: serializeLocation(task.location),
    stats: {
      assignments: task._count?.volunteerTasks ?? assignments.length,
      reports: task._count?.reports ?? 0,
    },
    myAssignment: myAssignment ? serializeAssignment(myAssignment) : null,
    assignments: includeAssignments ? assignments.map(serializeAssignment) : undefined,
  };
}

function ensureTaskOwner(task, volunteerId) {
  if (task.campaign.createdById !== volunteerId) {
    throw new AppError('غير مسموح لك بإدارة هذه المهمة', 403);
  }
}

async function getTaskOrThrow(taskId, options = {}) {
  const task = await prisma.task.findUnique({
    where: {
      id: taskId,
    },
    include: buildTaskInclude(options),
  });

  if (!task) {
    throw new AppError('المهمة غير موجودة', 404);
  }

  return task;
}

async function getCampaignForTaskManagement(campaignId, volunteerId) {
  const campaign = await prisma.campaign.findUnique({
    where: {
      id: campaignId,
    },
    select: {
      id: true,
      title: true,
      startDate: true,
      endDate: true,
      locationId: true,
      createdById: true,
    },
  });

  if (!campaign) {
    throw new AppError('الحملة غير موجودة', 404);
  }

  if (campaign.createdById !== volunteerId) {
    throw new AppError('غير مسموح لك بإدارة مهام هذه الحملة', 403);
  }

  return campaign;
}

function ensureTaskDateWithinCampaign(taskDate, campaign) {
  const campaignStartDate = new Date(campaign.startDate);
  const campaignEndDate = new Date(campaign.endDate);

  if (taskDate < campaignStartDate || taskDate > campaignEndDate) {
    throw new AppError('تاريخ المهمة يجب أن يقع داخل تاريخ الحملة', 400);
  }
}

async function syncTaskStatusFromAssignments(transactionClient, taskId) {
  const task = await transactionClient.task.findUnique({
    where: {
      id: taskId,
    },
    select: {
      status: true,
    },
  });

  if (!task || task.status === 'CANCELLED') {
    return;
  }

  const assignments = await transactionClient.volunteerTask.findMany({
    where: {
      taskId,
    },
    select: {
      status: true,
    },
  });

  let nextStatus = 'OPEN';

  if (assignments.length > 0) {
    const allAssignmentsClosed = assignments.every((assignment) =>
      ['COMPLETED', 'CANCELLED'].includes(assignment.status),
    );

    if (
      allAssignmentsClosed &&
      assignments.some((assignment) => assignment.status === 'COMPLETED')
    ) {
      nextStatus = 'COMPLETED';
    } else if (
      assignments.some((assignment) =>
        ['CHECKED_IN', 'CHECKED_OUT', 'COMPLETED'].includes(assignment.status),
      )
    ) {
      nextStatus = 'IN_PROGRESS';
    } else {
      nextStatus = 'ASSIGNED';
    }
  }

  if (task.status !== nextStatus) {
    await transactionClient.task.update({
      where: {
        id: taskId,
      },
      data: {
        status: nextStatus,
      },
    });
  }
}

async function listTasks(query, volunteerId) {
  const filters = validateTaskListQuery(query);
  const where = {};

  if (filters.campaignId) {
    where.campaignId = filters.campaignId;
  }

  if (filters.locationId) {
    where.locationId = filters.locationId;
  }

  if (filters.status) {
    where.status = filters.status;
  }

  if (filters.assignedToMe || query.mine === 'true') {
    where.volunteerTasks = {
      some: {
        volunteerId,
      },
    };
  } else if (filters.volunteerId) {
    where.volunteerTasks = {
      some: {
        volunteerId: filters.volunteerId,
      },
    };
  }

  const [tasks, total] = await Promise.all([
    prisma.task.findMany({
      where,
      include: buildTaskInclude({
        currentVolunteerId: volunteerId,
      }),
      orderBy: [
        { date: 'asc' },
        { id: 'desc' },
      ],
      skip: filters.skip,
      take: filters.limit,
    }),
    prisma.task.count({ where }),
  ]);

  return {
    message: 'تم جلب المهام بنجاح',
    pagination: serializePagination(filters.page, filters.limit, total),
    tasks: tasks.map((task) =>
      serializeTask(task, {
        currentVolunteerId: volunteerId,
      }),
    ),
  };
}

async function getTaskById(taskId, volunteerId) {
  const parsedTaskId = parsePositiveInteger(taskId, 'معرف المهمة');
  const task = await getTaskOrThrow(parsedTaskId, {
    currentVolunteerId: volunteerId,
    includeAssignments: true,
  });

  return {
    message: 'تم جلب بيانات المهمة بنجاح',
    task: serializeTask(task, {
      currentVolunteerId: volunteerId,
      includeAssignments: true,
    }),
  };
}

async function createTask(payload, volunteerId) {
  const validatedPayload = validateTaskCreatePayload(payload);
  const campaign = await getCampaignForTaskManagement(
    validatedPayload.campaignId,
    volunteerId,
  );

  ensureTaskDateWithinCampaign(validatedPayload.date, campaign);

  const task = await prisma.$transaction(async (transactionClient) => {
    const locationId =
      validatedPayload.locationId || validatedPayload.location
        ? await resolveLocationInput(transactionClient, validatedPayload)
        : campaign.locationId;

    return transactionClient.task.create({
      data: {
        title: validatedPayload.title,
        description: validatedPayload.description,
        campaignId: validatedPayload.campaignId,
        date: validatedPayload.date,
        startTime: validatedPayload.startTime,
        endTime: validatedPayload.endTime,
        status: validatedPayload.status,
        locationId,
      },
      include: buildTaskInclude({
        currentVolunteerId: volunteerId,
      }),
    });
  });

  return {
    message: 'تم إنشاء المهمة بنجاح',
    task: serializeTask(task, {
      currentVolunteerId: volunteerId,
    }),
  };
}

async function updateTask(taskId, payload, volunteerId) {
  const parsedTaskId = parsePositiveInteger(taskId, 'معرف المهمة');
  const validatedPayload = validateTaskUpdatePayload(payload);
  const existingTask = await getTaskOrThrow(parsedTaskId, {
    currentVolunteerId: volunteerId,
  });

  ensureTaskOwner(existingTask, volunteerId);

  if (Object.keys(validatedPayload).length === 0) {
    throw new AppError('لا توجد بيانات صالحة للتحديث', 400);
  }

  const campaign = await getCampaignForTaskManagement(existingTask.campaignId, volunteerId);
  const nextTaskDate = validatedPayload.date || existingTask.date;

  ensureTaskDateWithinCampaign(nextTaskDate, campaign);

  const nextStartTime =
    validatedPayload.startTime !== undefined ? validatedPayload.startTime : existingTask.startTime;
  const nextEndTime =
    validatedPayload.endTime !== undefined ? validatedPayload.endTime : existingTask.endTime;

  if (nextStartTime && nextEndTime && nextStartTime >= nextEndTime) {
    throw new AppError('وقت البداية يجب أن يكون قبل وقت النهاية', 400);
  }

  const task = await prisma.$transaction(async (transactionClient) => {
    const data = {
      title: validatedPayload.title,
      description: validatedPayload.description,
      date: validatedPayload.date,
      startTime: validatedPayload.startTime,
      endTime: validatedPayload.endTime,
      status: validatedPayload.status,
    };

    if (validatedPayload.locationId || validatedPayload.location) {
      data.locationId = await resolveLocationInput(transactionClient, validatedPayload);
    }

    return transactionClient.task.update({
      where: {
        id: parsedTaskId,
      },
      data: Object.fromEntries(
        Object.entries(data).filter(([, value]) => value !== undefined),
      ),
      include: buildTaskInclude({
        currentVolunteerId: volunteerId,
      }),
    });
  });

  return {
    message: 'تم تحديث المهمة بنجاح',
    task: serializeTask(task, {
      currentVolunteerId: volunteerId,
    }),
  };
}

async function listTaskAssignments(taskId, volunteerId) {
  const parsedTaskId = parsePositiveInteger(taskId, 'معرف المهمة');
  const task = await getTaskOrThrow(parsedTaskId, {
    includeAssignments: true,
  });

  ensureTaskOwner(task, volunteerId);

  return {
    message: 'تم جلب إسنادات المهمة بنجاح',
    assignments: (task.volunteerTasks || []).map(serializeAssignment),
  };
}

async function assignVolunteerToTask(taskId, payload, volunteerId) {
  const parsedTaskId = parsePositiveInteger(taskId, 'معرف المهمة');
  const validatedPayload = validateTaskAssignmentCreatePayload(payload);
  const task = await getTaskOrThrow(parsedTaskId);

  ensureTaskOwner(task, volunteerId);

  const volunteer = await prisma.volunteer.findUnique({
    where: {
      id: validatedPayload.volunteerId,
    },
    select: volunteerSummarySelect,
  });

  if (!volunteer) {
    throw new AppError('المتطوع غير موجود', 404);
  }

  const existingAssignment = await prisma.volunteerTask.findUnique({
    where: {
      volunteerId_taskId: {
        volunteerId: validatedPayload.volunteerId,
        taskId: parsedTaskId,
      },
    },
  });

  if (existingAssignment) {
    throw new AppError('هذا المتطوع مسند بالفعل إلى المهمة', 409);
  }

  const assignment = await prisma.$transaction(async (transactionClient) => {
    const createdAssignment = await transactionClient.volunteerTask.create({
      data: {
        volunteerId: validatedPayload.volunteerId,
        taskId: parsedTaskId,
        status: validatedPayload.status,
      },
      include: {
        volunteer: {
          select: volunteerSummarySelect,
        },
      },
    });

    await syncTaskStatusFromAssignments(transactionClient, parsedTaskId);

    return createdAssignment;
  });

  return {
    message: 'تم إسناد المتطوع إلى المهمة بنجاح',
    assignment: serializeAssignment(assignment),
  };
}

async function updateTaskAssignment(taskId, assignmentVolunteerId, payload, currentVolunteerId) {
  const parsedTaskId = parsePositiveInteger(taskId, 'معرف المهمة');
  const parsedVolunteerId = parsePositiveInteger(assignmentVolunteerId, 'معرف المتطوع');
  const validatedPayload = validateTaskAssignmentUpdatePayload(payload);

  const assignment = await prisma.volunteerTask.findUnique({
    where: {
      volunteerId_taskId: {
        volunteerId: parsedVolunteerId,
        taskId: parsedTaskId,
      },
    },
    include: {
      volunteer: {
        select: volunteerSummarySelect,
      },
      task: {
        include: {
          campaign: {
            select: {
              createdById: true,
            },
          },
        },
      },
    },
  });

  if (!assignment) {
    throw new AppError('إسناد المهمة غير موجود', 404);
  }

  const isTaskOwner = assignment.task.campaign.createdById === currentVolunteerId;
  const isAssignedVolunteer = assignment.volunteerId === currentVolunteerId;

  if (!isTaskOwner && !isAssignedVolunteer) {
    throw new AppError('غير مسموح لك بتحديث هذا الإسناد', 403);
  }

  if (
    assignment.status === 'COMPLETED' &&
    validatedPayload.status &&
    validatedPayload.status !== 'COMPLETED'
  ) {
    throw new AppError('لا يمكن تغيير الإسناد بعد اكتماله', 400);
  }

  const nextCheckInTime =
    validatedPayload.checkInTime !== undefined
      ? validatedPayload.checkInTime
      : assignment.checkInTime;
  const nextCheckOutTime =
    validatedPayload.checkOutTime !== undefined
      ? validatedPayload.checkOutTime
      : assignment.checkOutTime;

  if (nextCheckInTime && nextCheckOutTime && nextCheckInTime >= nextCheckOutTime) {
    throw new AppError('وقت الحضور يجب أن يكون قبل وقت الانصراف', 400);
  }

  const updatedAssignment = await prisma.$transaction(async (transactionClient) => {
    const assignmentRecord = await transactionClient.volunteerTask.update({
      where: {
        volunteerId_taskId: {
          volunteerId: parsedVolunteerId,
          taskId: parsedTaskId,
        },
      },
      data: validatedPayload,
      include: {
        volunteer: {
          select: volunteerSummarySelect,
        },
      },
    });

    await syncTaskStatusFromAssignments(transactionClient, parsedTaskId);

    return assignmentRecord;
  });

  return {
    message: 'تم تحديث إسناد المهمة بنجاح',
    assignment: serializeAssignment(updatedAssignment),
  };
}

module.exports = {
  assignVolunteerToTask,
  createTask,
  getTaskById,
  listTaskAssignments,
  listTasks,
  updateTask,
  updateTaskAssignment,
};
