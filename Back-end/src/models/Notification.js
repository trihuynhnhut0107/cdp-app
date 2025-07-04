const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/sequelize.config");
const Notification = sequelize.define(
  "Notification",
  {
    id: {
      type: DataTypes.UUID, // Use DataTypes.INTEGER if you prefer INT
      defaultValue: DataTypes.UUIDV4, // Remove if using INT
      primaryKey: true,
      allowNull: false,
    },
    title: {
      type: DataTypes.TEXT,
      allowNull: false,
    },
    message: {
      type: DataTypes.TEXT,
      allowNull: false,
    },
    type: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    survey_id: {
      type: DataTypes.UUID,
      allowNull: true,
      references: {
        model: "Surveys",
        key: "id",
      },
    },
  },
  {
    tableName: "Notifications",
    timestamps: true,
  }
);

module.exports = Notification;
