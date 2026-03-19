const prisma = require('../lib/prisma');
const AppError = require('../utils/app-error');
const {
  serializePagination,
  serializeVolunteerSummary,
} = require('../utils/serializers');
const {
  parsePositiveInteger,
  validateSosRequestCreatePayload,
  validateSosRequestListQuery,
  validateSosRequestStatusPayload,
} = require('../validators/resource.validators');

const volunteerSummarySelect = {
  id: true,
  fullName: true,
  nationalId: true,
  email: true,
  phone: true,
  status: true,
};

const sosRequestInclude = {
  volunteer: {
    select: volunteerSummarySelect,
  },
};

function decimalToNumber(value) {
  return Number(value);
}

function serializeSosRequest(sosRequest) {
  return {
    id: sosRequest.id,
    volunteerId: sosRequest.volunteerId,
    latitude: decimalToNumber(sosRequest.latitude),
    longitude: decimalToNumber(sosRequest.longitude),
    status: sosRequest.status,
    createdAt: sosRequest.createdAt?.toISOString() ?? null,
    resolvedAt: sosRequest.resolvedAt?.toISOString() ?? null,
    volunteer: serializeVolunteerSummary(sosRequest.volunteer),
  };
}

async function getSosRequestOrThrow(requestId) {
  const sosRequest = await prisma.sosRequest.findUnique({
    where: {
      id: requestId,
    },
    include: sosRequestInclude,
  });

  if (!sosRequest) {
    throw new AppError('طلب الاستغاثة غير موجود', 404);
  }

  return sosRequest;
}

async function listSosRequests(query, volunteerId) {
  const filters = validateSosRequestListQuery(query);
  const where = {};

  if (filters.status) {
    where.status = filters.status;
  }

  if (filters.volunteerId) {
    where.volunteerId = filters.volunteerId;
  }

  if (filters.mine || query.mine === 'true') {
    where.volunteerId = volunteerId;
  }

  const [requests, total] = await Promise.all([
    prisma.sosRequest.findMany({
      where,
      include: sosRequestInclude,
      orderBy: {
        createdAt: 'desc',
      },
      skip: filters.skip,
      take: filters.limit,
    }),
    prisma.sosRequest.count({ where }),
  ]);

  return {
    message: 'تم جلب طلبات الاستغاثة بنجاح',
    pagination: serializePagination(filters.page, filters.limit, total),
    requests: requests.map(serializeSosRequest),
  };
}

async function getSosRequestById(requestId) {
  const parsedRequestId = parsePositiveInteger(requestId, 'معرف الاستغاثة');
  const sosRequest = await getSosRequestOrThrow(parsedRequestId);

  return {
    message: 'تم جلب بيانات الاستغاثة بنجاح',
    request: serializeSosRequest(sosRequest),
  };
}

async function createSosRequest(payload, volunteerId) {
  const validatedPayload = validateSosRequestCreatePayload(payload);

  const sosRequest = await prisma.sosRequest.create({
    data: {
      volunteerId,
      latitude: validatedPayload.latitude,
      longitude: validatedPayload.longitude,
    },
    include: sosRequestInclude,
  });

  return {
    message: 'تم إنشاء طلب الاستغاثة بنجاح',
    request: serializeSosRequest(sosRequest),
  };
}

async function updateSosRequestStatus(requestId, payload, volunteerId) {
  const parsedRequestId = parsePositiveInteger(requestId, 'معرف الاستغاثة');
  const validatedPayload = validateSosRequestStatusPayload(payload);
  const existingRequest = await getSosRequestOrThrow(parsedRequestId);

  if (
    validatedPayload.status === 'CANCELLED' &&
    existingRequest.volunteerId !== volunteerId
  ) {
    throw new AppError('فقط صاحب الطلب يمكنه إلغاء الاستغاثة', 403);
  }

  if (
    existingRequest.volunteerId !== volunteerId &&
    !['RESPONDED', 'RESOLVED'].includes(validatedPayload.status)
  ) {
    throw new AppError('غير مسموح لك بتغيير حالة هذا الطلب إلى هذه القيمة', 403);
  }

  const sosRequest = await prisma.sosRequest.update({
    where: {
      id: parsedRequestId,
    },
    data: {
      status: validatedPayload.status,
      resolvedAt:
        validatedPayload.status === 'RESOLVED' ? new Date() : null,
    },
    include: sosRequestInclude,
  });

  return {
    message: 'تم تحديث حالة طلب الاستغاثة بنجاح',
    request: serializeSosRequest(sosRequest),
  };
}

module.exports = {
  createSosRequest,
  getSosRequestById,
  listSosRequests,
  updateSosRequestStatus,
};
