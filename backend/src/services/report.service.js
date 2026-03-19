const prisma = require('../lib/prisma');
const AppError = require('../utils/app-error');
const {
  serializePagination,
  serializeVolunteerSummary,
} = require('../utils/serializers');
const {
  parsePositiveInteger,
  validateReportCreatePayload,
  validateReportListQuery,
  validateReportUpdatePayload,
} = require('../validators/resource.validators');

const volunteerSummarySelect = {
  id: true,
  fullName: true,
  nationalId: true,
  email: true,
  phone: true,
  status: true,
};

const reportInclude = {
  volunteer: {
    select: volunteerSummarySelect,
  },
  task: {
    select: {
      id: true,
      title: true,
      date: true,
      status: true,
    },
  },
  campaign: {
    select: {
      id: true,
      title: true,
      status: true,
      createdById: true,
    },
  },
};

function formatDateOnly(value) {
  return value ? new Date(value).toISOString().slice(0, 10) : null;
}

function serializeReport(report) {
  return {
    id: report.id,
    volunteerId: report.volunteerId,
    taskId: report.taskId,
    campaignId: report.campaignId,
    notes: report.notes,
    voiceNote: report.voiceNote,
    images: Array.isArray(report.images) ? report.images : [],
    rating: report.rating,
    createdAt: report.createdAt?.toISOString() ?? null,
    volunteer: serializeVolunteerSummary(report.volunteer),
    task: report.task
      ? {
          id: report.task.id,
          title: report.task.title,
          date: formatDateOnly(report.task.date),
          status: report.task.status,
        }
      : null,
    campaign: report.campaign
      ? {
          id: report.campaign.id,
          title: report.campaign.title,
          status: report.campaign.status,
          createdById: report.campaign.createdById,
        }
      : null,
  };
}

function buildReportAccessWhere(volunteerId) {
  return {
    OR: [
      {
        volunteerId,
      },
      {
        campaign: {
          is: {
            createdById: volunteerId,
          },
        },
      },
    ],
  };
}

async function getReportOrThrow(reportId, volunteerId) {
  const report = await prisma.report.findFirst({
    where: {
      AND: [
        {
          id: reportId,
        },
        buildReportAccessWhere(volunteerId),
      ],
    },
    include: reportInclude,
  });

  if (!report) {
    throw new AppError('التقرير غير موجود أو لا تملك صلاحية الوصول إليه', 404);
  }

  return report;
}

async function listReports(query, volunteerId) {
  const filters = validateReportListQuery(query);
  const where = {
    AND: [buildReportAccessWhere(volunteerId)],
  };

  if (filters.mine || query.mine === 'true') {
    where.AND.push({
      volunteerId,
    });
  }

  if (filters.volunteerId) {
    where.AND.push({
      volunteerId: filters.volunteerId,
    });
  }

  if (filters.campaignId) {
    where.AND.push({
      campaignId: filters.campaignId,
    });
  }

  if (filters.taskId) {
    where.AND.push({
      taskId: filters.taskId,
    });
  }

  const [reports, total] = await Promise.all([
    prisma.report.findMany({
      where,
      include: reportInclude,
      orderBy: {
        createdAt: 'desc',
      },
      skip: filters.skip,
      take: filters.limit,
    }),
    prisma.report.count({ where }),
  ]);

  return {
    message: 'تم جلب التقارير بنجاح',
    pagination: serializePagination(filters.page, filters.limit, total),
    reports: reports.map(serializeReport),
  };
}

async function getReportById(reportId, volunteerId) {
  const parsedReportId = parsePositiveInteger(reportId, 'معرف التقرير');
  const report = await getReportOrThrow(parsedReportId, volunteerId);

  return {
    message: 'تم جلب بيانات التقرير بنجاح',
    report: serializeReport(report),
  };
}

async function createReport(payload, volunteerId) {
  const validatedPayload = validateReportCreatePayload(payload);
  const task = await prisma.task.findUnique({
    where: {
      id: validatedPayload.taskId,
    },
    include: {
      campaign: {
        select: {
          id: true,
          createdById: true,
        },
      },
      volunteerTasks: {
        where: {
          volunteerId,
        },
      },
    },
  });

  if (!task) {
    throw new AppError('المهمة غير موجودة', 404);
  }

  if (validatedPayload.campaignId && validatedPayload.campaignId !== task.campaignId) {
    throw new AppError('الحملة المرسلة لا تطابق الحملة المرتبطة بالمهمة', 400);
  }

  const isAssignedVolunteer = task.volunteerTasks.length > 0;
  const isCampaignOwner = task.campaign.createdById === volunteerId;

  if (!isAssignedVolunteer && !isCampaignOwner) {
    throw new AppError('يجب أن تكون مسندًا لهذه المهمة أو منشئ الحملة لإنشاء تقرير', 403);
  }

  const report = await prisma.report.create({
    data: {
      volunteerId,
      taskId: task.id,
      campaignId: task.campaignId,
      notes: validatedPayload.notes,
      voiceNote: validatedPayload.voiceNote,
      images: validatedPayload.images || [],
      rating: validatedPayload.rating,
    },
    include: reportInclude,
  });

  return {
    message: 'تم إنشاء التقرير بنجاح',
    report: serializeReport(report),
  };
}

async function updateReport(reportId, payload, volunteerId) {
  const parsedReportId = parsePositiveInteger(reportId, 'معرف التقرير');
  const validatedPayload = validateReportUpdatePayload(payload);
  const existingReport = await prisma.report.findUnique({
    where: {
      id: parsedReportId,
    },
  });

  if (!existingReport) {
    throw new AppError('التقرير غير موجود', 404);
  }

  if (existingReport.volunteerId !== volunteerId) {
    throw new AppError('غير مسموح لك بتحديث هذا التقرير', 403);
  }

  const report = await prisma.report.update({
    where: {
      id: parsedReportId,
    },
    data: validatedPayload,
    include: reportInclude,
  });

  return {
    message: 'تم تحديث التقرير بنجاح',
    report: serializeReport(report),
  };
}

module.exports = {
  createReport,
  getReportById,
  listReports,
  updateReport,
};
