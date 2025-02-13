const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/sequelize.config");

const Option = sequelize.define("Option", {
  id: {
    type: DataTypes.UUID,
    primaryKey: true,
    defaultValue: DataTypes.UUIDV4,
  },
  option_content: {
    type: DataTypes.STRING,
    allowNull: false,
  },
});

module.exports = Option;
