const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/sequelize.config");

const Answer = sequelize.define("Answer", {
  id: {
    type: DataTypes.UUID,
    primaryKey: true,
    defaultValue: DataTypes.UUIDV4,
  },
  question_id: {
    type: DataTypes.UUID,
    allowNull: false,
  },
  option_id: {
    type: DataTypes.UUID,
    allowNull: false,
  },
  user_id: {
    type: DataTypes.UUID,
    allowNull: false,
  },
});

module.exports = Answer;
