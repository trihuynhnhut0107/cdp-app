const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/sequelize.config");

const TextAnswer = sequelize.define("TextAnswer", {
  id: {
    type: DataTypes.UUID,
    primaryKey: true,
    defaultValue: DataTypes.UUIDV4,
  },
  question_id: {
    type: DataTypes.UUID,
    allowNull: false,
  },
  user_id: {
    type: DataTypes.UUID,
    allowNull: false,
  },
  answer: {
    type: DataTypes.STRING,
    allowNull: false,
  },
});

module.exports = TextAnswer;
