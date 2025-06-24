"use strict";
const express = require("express");
const asyncHandler = require("../helpers/asyncHandler");
const notificationController = require("../controllers/notification.controller");

const router = express.Router();

router.get("/", asyncHandler(notificationController.getAllNotifications));
router.get(
  "/:id",
  asyncHandler(notificationController.getNotificationsByUserId)
);
module.exports = router;
