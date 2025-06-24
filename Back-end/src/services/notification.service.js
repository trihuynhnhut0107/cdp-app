"use strict";

const Notification = require("../models/Notification");
const BaseService = require("./base.service");
const { getSocketIO } = require("../utils/socket.io");
const User = require("../models/User");
const Survey = require("../models/Survey");
const { where } = require("sequelize");
const UserNotification = require("../models/UserNotification");

class NotificationService extends BaseService {
  static model = Notification;

  /**
   * Create a notification and emit it to the user via Socket.IO
   * @param {string} userId
   * @param {string} title
   * @param {string} message
   * @param {string} [type="info"]
   * @returns {Promise<Notification>}
   */
  static async createAndEmit(userId, title, message, type = "info") {
    const notification = await this.model.create({
      title,
      message,
      type,
    });

    console.log("Notification created:", notification); // Debugging line

    await UserNotification.create({
      user_id: userId,
      notification_id: notification.id,
    });

    const io = getSocketIO();
    io.emit("notification", {
      title,
      message,
      type,
      createdAt: notification.createdAt,
    });
    return notification;
  }

  static async createNotificationForNewSurvey(survey_id) {
    // Fetch all users and the survey in parallel
    const [userList, foundSurvey] = await Promise.all([
      User.findAll(),
      Survey.findOne({ where: { id: survey_id } }),
    ]);
    if (!foundSurvey) return;

    await Promise.all(
      userList.map(async (user) => {
        await this.createAndEmit(
          user.id,
          "New survey!",
          `${foundSurvey.survey_name} is now available!`,
          "survey"
        );
      })
    );
  }

  /**
   * Get all notifications
   * @returns {Promise<Array<Notification>>}
   */
  static async getAllNotification() {
    return await Notification.findAll();
  }
  /**
   * Get all notifications for a specific user
   * @param {string} userId
   * @returns {Promise<Array<UserNotification>>}
   */
  static async getNotificationsByUserId(userId) {
    return await UserNotification.findAll({
      where: { user_id: userId },
      include: [
        {
          model: Notification,
          attributes: ["title", "message", "type"],
        },
      ],
    });
  }
}

module.exports = NotificationService;
