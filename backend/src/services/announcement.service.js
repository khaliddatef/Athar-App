const prisma = require('../lib/prisma');
const { serializePagination } = require('../utils/serializers');
const { validateAnnouncementListQuery } = require('../validators/resource.validators');

function serializeAnnouncement(announcement) {
  if (!announcement) {
    return null;
  }

  return {
    id: announcement.id,
    title: announcement.title,
    content: announcement.content,
    image: announcement.image,
    isPinned: announcement.isPinned,
    createdAt: announcement.createdAt?.toISOString() ?? null,
  };
}

async function findFeaturedAnnouncement(dbClient = prisma) {
  const announcement = await dbClient.announcement.findFirst({
    orderBy: [
      { isPinned: 'desc' },
      { createdAt: 'desc' },
    ],
  });

  return serializeAnnouncement(announcement);
}

async function listAnnouncements(query = {}) {
  const filters = validateAnnouncementListQuery(query);
  const where = {};

  if (filters.pinnedOnly) {
    where.isPinned = true;
  }

  const [announcements, total] = await Promise.all([
    prisma.announcement.findMany({
      where,
      orderBy: [
        { isPinned: 'desc' },
        { createdAt: 'desc' },
      ],
      skip: filters.skip,
      take: filters.limit,
    }),
    prisma.announcement.count({ where }),
  ]);

  return {
    message: 'تم جلب الإعلانات بنجاح',
    pagination: serializePagination(filters.page, filters.limit, total),
    announcements: announcements.map(serializeAnnouncement),
  };
}

module.exports = {
  findFeaturedAnnouncement,
  listAnnouncements,
  serializeAnnouncement,
};
