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
}

module.exports = new NotificationController();
