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
   * @param {string} [survey_id=null]
   * @returns {Promise<Notification>}
   */
  static async createAndEmit(
    userId,
    title,
    message,
    type = "info",
    survey_id = null
  ) {
    const notification = await this.model.create({
      title,
      message,
      type,
      survey_id,
    });

    console.log("Notification created:", notification); // Debugging line

    await UserNotification.create({
      user_id: userId,
      notification_id: notification.id,
    });

    const io = getSocketIO();
    io.emit("notification", {
      id: notification.id,
      title,
      message,
      type,
      survey_id: notification.survey_id,
      createdAt: notification.createdAt,
    });
    // Check if the event was emitted properly
    if (io.engine.clientsCount === 0) {
      console.warn("No connected clients to emit notification.");
    } else {
      console.log(`Notification emitted to ${io.engine.clientsCount} clients.`);
    }
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
          "survey",
          survey_id
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
          attributes: [
            "id",
            "title",
            "message",
            "type",
            "survey_id",
            "createdAt",
          ],
        },
      ],
      attributes: ["is_read", "createdAt", "updatedAt"],
      order: [["createdAt", "DESC"]],
    });
  }

  /**
   * Mark a notification as read for a specific user
   * @param {string} userId
   * @param {string} notificationId
   * @returns {Promise<boolean>}
   */
  static async markAsRead(userId, notificationId) {
    const [affectedRows] = await UserNotification.update(
      { is_read: true },
      {
        where: {
          user_id: userId,
          notification_id: notificationId,
        },
      }
    );
    return affectedRows > 0;
  }

  /**
   * Mark a notification as unread for a specific user
   * @param {string} userId
   * @param {string} notificationId
   * @returns {Promise<boolean>}
   */
  static async markAsUnread(userId, notificationId) {
    const [affectedRows] = await UserNotification.update(
      { is_read: false },
      {
        where: {
          user_id: userId,
          notification_id: notificationId,
        },
      }
    );
    return affectedRows > 0;
  }

  /**
   * Mark all notifications as read for a specific user
   * @param {string} userId
   * @returns {Promise<boolean>}
   */
  static async markAllAsRead(userId) {
    const [affectedRows] = await UserNotification.update(
      { is_read: true },
      {
        where: {
          user_id: userId,
        },
      }
    );
    return affectedRows > 0;
  }

  /**
   * Delete a notification for a specific user
   * @param {string} userId
   * @param {string} notificationId
   * @returns {Promise<boolean>}
   */
  static async deleteNotification(userId, notificationId) {
    const affectedRows = await UserNotification.destroy({
      where: {
        user_id: userId,
        notification_id: notificationId,
      },
    });
    return affectedRows > 0;
  }
}

module.exports = NotificationService;
