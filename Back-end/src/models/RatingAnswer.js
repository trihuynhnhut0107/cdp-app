const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/sequelize.config");

const RatingAnswer = sequelize.define("RatingAnswer", {
  id: {
    type: DataTypes.UUID,
    primaryKey: true,
    defaultValue: DataTypes.UUIDV4,
  },
  question_id: {
    type: DataTypes.UUID,
    allowNull: false,
    primaryKey: true,
  },
  user_id: {
    type: DataTypes.UUID,
    allowNull: false,
    primaryKey: true,
  },
  score: {
    type: DataTypes.INTEGER,
    allowNull: false,
    validate: {
      min: 1,
      max: 5,
    },
  },
});

module.exports = RatingAnswer;
