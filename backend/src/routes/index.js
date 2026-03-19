const express = require('express');

const prisma = require('../lib/prisma');
const authRoutes = require('./auth.routes');
const campaignRoutes = require('./campaign.routes');
const reportRoutes = require('./report.routes');
const sosRequestRoutes = require('./sos-request.routes');
const taskRoutes = require('./task.routes');

const router = express.Router();

router.get('/health', async (req, res) => {
  try {
    await prisma.$queryRawUnsafe('SELECT 1 AS ok');

    res.status(200).json({
      success: true,
      message: 'Sanad backend and database are running',
      data: {
        timestamp: new Date().toISOString(),
        database: 'connected',
      },
    });
  } catch (error) {
    res.status(503).json({
      success: false,
      message: 'Sanad backend is running but database is unavailable',
      data: {
        timestamp: new Date().toISOString(),
        database: 'disconnected',
        reason: error.message,
      },
    });
  }
});

router.use('/auth', authRoutes);
router.use('/campaigns', campaignRoutes);
router.use('/tasks', taskRoutes);
router.use('/reports', reportRoutes);
router.use('/sos-requests', sosRequestRoutes);

module.exports = router;
