const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/sequelize.config");

const SelectionAnswer = sequelize.define("SelectionAnswer", {
  question_id: {
    type: DataTypes.UUID,
    allowNull: false,
    primaryKey: true,
  },
  option_id: {
    type: DataTypes.UUID,
    allowNull: false,
    primaryKey: true,
  },
  user_id: {
    type: DataTypes.UUID,
    allowNull: false,
    primaryKey: true,
  },
});

module.exports = SelectionAnswer;
