const prisma = require('../lib/prisma');
const AppError = require('../utils/app-error');
const {
  serializeLocation,
  serializePagination,
  serializeVolunteerSummary,
} = require('../utils/serializers');
const {
  parsePositiveInteger,
  validateCampaignCreatePayload,
  validateCampaignListQuery,
  validateCampaignUpdatePayload,
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

const campaignInclude = {
  location: true,
  createdBy: {
    select: volunteerSummarySelect,
  },
  _count: {
    select: {
      tasks: true,
      reports: true,
      ratings: true,
    },
  },
};

function formatDateOnly(value) {
  return value ? new Date(value).toISOString().slice(0, 10) : null;
}

function serializeCampaign(campaign) {
  return {
    id: campaign.id,
    title: campaign.title,
    description: campaign.description,
    startDate: formatDateOnly(campaign.startDate),
    endDate: formatDateOnly(campaign.endDate),
    status: campaign.status,
    location: serializeLocation(campaign.location),
    createdBy: serializeVolunteerSummary(campaign.createdBy),
    stats: {
      tasks: campaign._count?.tasks ?? 0,
      reports: campaign._count?.reports ?? 0,
      ratings: campaign._count?.ratings ?? 0,
    },
  };
}

async function getCampaignOrThrow(campaignId) {
  const campaign = await prisma.campaign.findUnique({
    where: {
      id: campaignId,
    },
    include: campaignInclude,
  });

  if (!campaign) {
    throw new AppError('الحملة غير موجودة', 404);
  }

  return campaign;
}

function ensureCampaignOwner(campaign, volunteerId) {
  if (campaign.createdById !== volunteerId) {
    throw new AppError('غير مسموح لك بإدارة هذه الحملة', 403);
  }
}

async function listCampaigns(query, volunteerId) {
  const filters = validateCampaignListQuery(query);
  const where = {};

  if (filters.status) {
    where.status = filters.status;
  }

  if (filters.createdById) {
    where.createdById = filters.createdById;
  }

  if (filters.locationId) {
    where.locationId = filters.locationId;
  }

  if (query.mine === 'true') {
    where.createdById = volunteerId;
  }

  const [campaigns, total] = await Promise.all([
    prisma.campaign.findMany({
      where,
      include: campaignInclude,
      orderBy: [
        { startDate: 'asc' },
        { id: 'desc' },
      ],
      skip: filters.skip,
      take: filters.limit,
    }),
    prisma.campaign.count({ where }),
  ]);

  return {
    message: 'تم جلب الحملات بنجاح',
    pagination: serializePagination(filters.page, filters.limit, total),
    campaigns: campaigns.map(serializeCampaign),
  };
}

async function getCampaignById(campaignId) {
  const parsedCampaignId = parsePositiveInteger(campaignId, 'معرف الحملة');
  const campaign = await getCampaignOrThrow(parsedCampaignId);

  return {
    message: 'تم جلب بيانات الحملة بنجاح',
    campaign: serializeCampaign(campaign),
  };
}

async function createCampaign(payload, volunteerId) {
  const validatedPayload = validateCampaignCreatePayload(payload);

  const campaign = await prisma.$transaction(async (transactionClient) => {
    const locationId = await resolveLocationInput(transactionClient, validatedPayload);

    return transactionClient.campaign.create({
      data: {
        title: validatedPayload.title,
        description: validatedPayload.description,
        startDate: validatedPayload.startDate,
        endDate: validatedPayload.endDate,
        status: validatedPayload.status,
        locationId,
        createdById: volunteerId,
      },
      include: campaignInclude,
    });
  });

  return {
    message: 'تم إنشاء الحملة بنجاح',
    campaign: serializeCampaign(campaign),
  };
}

async function updateCampaign(campaignId, payload, volunteerId) {
  const parsedCampaignId = parsePositiveInteger(campaignId, 'معرف الحملة');
  const validatedPayload = validateCampaignUpdatePayload(payload);
  const existingCampaign = await getCampaignOrThrow(parsedCampaignId);

  ensureCampaignOwner(existingCampaign, volunteerId);

  if (Object.keys(validatedPayload).length === 0) {
    throw new AppError('لا توجد بيانات صالحة للتحديث', 400);
  }

  const nextStartDate = validatedPayload.startDate || existingCampaign.startDate;
  const nextEndDate = validatedPayload.endDate || existingCampaign.endDate;

  if (nextStartDate > nextEndDate) {
    throw new AppError('تاريخ بداية الحملة يجب أن يكون قبل أو مساويًا لتاريخ النهاية', 400);
  }

  const campaign = await prisma.$transaction(async (transactionClient) => {
    const data = {
      title: validatedPayload.title,
      description: validatedPayload.description,
      startDate: validatedPayload.startDate,
      endDate: validatedPayload.endDate,
      status: validatedPayload.status,
    };

    if (validatedPayload.locationId || validatedPayload.location) {
      data.locationId = await resolveLocationInput(transactionClient, validatedPayload);
    }

    return transactionClient.campaign.update({
      where: {
        id: parsedCampaignId,
      },
      data: Object.fromEntries(
        Object.entries(data).filter(([, value]) => value !== undefined),
      ),
      include: campaignInclude,
    });
  });

  return {
    message: 'تم تحديث الحملة بنجاح',
    campaign: serializeCampaign(campaign),
  };
}

module.exports = {
  createCampaign,
  getCampaignById,
  listCampaigns,
  updateCampaign,
};
