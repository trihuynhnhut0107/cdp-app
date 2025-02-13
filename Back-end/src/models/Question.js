const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/sequelize.config");

const Question = sequelize.define("Question", {
  id: {
    type: DataTypes.UUID,
    primaryKey: true,
    defaultValue: DataTypes.UUIDV4,
  },
  question_content: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  options_quantity: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
});

module.exports = Question;
