"use strict";
const express = require("express");
const asyncHandler = require("../helpers/asyncHandler");
const notificationController = require("../controllers/notification.controller");

const router = express.Router();

// Get all notifications
router.get("/", asyncHandler(notificationController.getAllNotifications));

// Get notifications for a specific user
router.get(
  "/:id",
  asyncHandler(notificationController.getNotificationsByUserId)
);

// Mark a specific notification as read
router.patch(
  "/:userId/:notificationId/read",
  asyncHandler(notificationController.markAsRead)
);

// Mark a specific notification as unread
router.patch(
  "/:userId/:notificationId/unread",
  asyncHandler(notificationController.markAsUnread)
);

// Mark all notifications as read for a user
router.patch(
  "/:userId/read-all",
  asyncHandler(notificationController.markAllAsRead)
);

// Delete a specific notification
router.delete(
  "/:userId/:notificationId",
  asyncHandler(notificationController.deleteNotification)
);

module.exports = router;
