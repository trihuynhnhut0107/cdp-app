const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/sequelize.config");

const Survey = sequelize.define("Survey", {
  id: {
    type: DataTypes.UUID,
    primaryKey: true,
    defaultValue: DataTypes.UUIDV4,
  },
  question_quantity: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
  survey_name: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  point: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
});

module.exports = Survey;
