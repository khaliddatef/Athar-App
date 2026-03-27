const express = require('express');

const announcementController = require('../controllers/announcement.controller');
const { requireAuth } = require('../middleware/auth.middleware');

const router = express.Router();

router.use(requireAuth);

router.get('/', announcementController.listAnnouncements);

module.exports = router;
