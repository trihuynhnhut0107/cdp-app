"use strict";

const NotificationService = require("../services/notification.service");
const asyncHandler = require("../helpers/asyncHandler");
const { OK } = require("../core/success.response");

class NotificationController {
  getAllNotifications = async (req, res, next) => {
    new OK({
      message: "Notifications fetched successfully",
      metadata: await NotificationService.getAllNotification(),
    }).send(res);
  };
  getNotificationsByUserId = async (req, res, next) => {
    const { id } = req.params;
    new OK({
      message: "User notifications fetched successfully",
      metadata: await NotificationService.getNotificationsByUserId(id),
    }).send(res);
  };
  markAsRead = async (req, res, next) => {
    const { userId, notificationId } = req.params;
    const result = await NotificationService.markAsRead(userId, notificationId);

    if (result) {
      new OK({
        message: "Notification marked as read successfully",
        metadata: { success: true },
      }).send(res);
    } else {
      throw new Error("Failed to mark notification as read");
    }
  };

  markAsUnread = async (req, res, next) => {
    const { userId, notificationId } = req.params;
    const result = await NotificationService.markAsUnread(
      userId,
      notificationId
    );

    if (result) {
      new OK({
        message: "Notification marked as unread successfully",
        metadata: { success: true },
      }).send(res);
    } else {
      throw new Error("Failed to mark notification as unread");
    }
  };

  markAllAsRead = async (req, res, next) => {
    const { userId } = req.params;
    const result = await NotificationService.markAllAsRead(userId);

    if (result) {
      new OK({
        message: "All notifications marked as read successfully",
        metadata: { success: true },
      }).send(res);
    } else {
      throw new Error("Failed to mark all notifications as read");
    }
  };

  deleteNotification = async (req, res, next) => {
    const { userId, notificationId } = req.params;
    const result = await NotificationService.deleteNotification(
      userId,
      notificationId
    );

    if (result) {
      new OK({
        message: "Notification deleted successfully",
        metadata: { success: true },
      }).send(res);
    } else {
      throw new Error("Failed to delete notification");
    }
  };
}

module.exports = new NotificationController();
