const sosRequestService = require('../services/sos-request.service');
const asyncHandler = require('../utils/async-handler');

const listSosRequests = asyncHandler(async (req, res) => {
  const result = await sosRequestService.listSosRequests(req.query, req.user.id);

  res.status(200).json({
    success: true,
    ...result,
  });
});

const getSosRequestById = asyncHandler(async (req, res) => {
  const result = await sosRequestService.getSosRequestById(req.params.requestId);

  res.status(200).json({
    success: true,
    ...result,
  });
});

const createSosRequest = asyncHandler(async (req, res) => {
  const result = await sosRequestService.createSosRequest(req.body, req.user.id);

  res.status(201).json({
    success: true,
    ...result,
  });
});

const updateSosRequestStatus = asyncHandler(async (req, res) => {
  const result = await sosRequestService.updateSosRequestStatus(
    req.params.requestId,
    req.body,
    req.user.id,
  );

  res.status(200).json({
    success: true,
    ...result,
  });
});

module.exports = {
  createSosRequest,
  getSosRequestById,
  listSosRequests,
  updateSosRequestStatus,
};
