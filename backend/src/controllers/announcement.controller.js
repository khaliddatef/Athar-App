const asyncHandler = require('../utils/async-handler');
const announcementService = require('../services/announcement.service');

const listAnnouncements = asyncHandler(async (req, res) => {
  const result = await announcementService.listAnnouncements(req.query);

  res.status(200).json({
    success: true,
    ...result,
  });
});

module.exports = {
  listAnnouncements,
};
