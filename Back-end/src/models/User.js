const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/sequelize.config");

const User = sequelize.define("User", {
  id: {
    type: DataTypes.UUID,
    primaryKey: true,
    defaultValue: DataTypes.UUIDV4,
  },
  name: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  email: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  password: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  point: {
    type: DataTypes.INTEGER,
    defaultValue: 0,
    allowNull: false,
  },
});
module.exports = User;
