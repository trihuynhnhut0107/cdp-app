const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/sequelize.config");
const User = require("./User");
const Notification = require("./Notification");

const UserNotification = sequelize.define(
  "UserNotification",
  {
    user_id: {
      type: DataTypes.UUID,
      primaryKey: true,
      allowNull: false,
    },
    notification_id: {
      type: DataTypes.UUID,
      primaryKey: true,
      allowNull: false,
    },
    is_read: {
      type: DataTypes.BOOLEAN,
      defaultValue: false,
    },
  },
  {
    tableName: "UserNotifications",
    timestamps: true,
  }
);

module.exports = UserNotification;
