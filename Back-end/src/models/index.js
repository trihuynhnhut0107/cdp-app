const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/sequelize.config");
const Answer = require("./Answer");
const Option = require("./Option");
const Question = require("./Question");
const Survey = require("./Survey");
const User = require("./User");

// Array of models
const models = { User, Question, Answer, Option, Survey };

Question.belongsTo(Survey, {
  foreignKey: { name: "survey_id", type: DataTypes.UUID },
  onDelete: "CASCADE",
});
Survey.hasMany(Question, {
  foreignKey: { name: "survey_id", type: DataTypes.UUID },
  onDelete: "CASCADE",
});

Option.belongsTo(Question, {
  foreignKey: { name: "question_id", type: DataTypes.UUID },
  onDelete: "CASCADE",
});
Question.hasMany(Option, {
  foreignKey: { name: "question_id", type: DataTypes.UUID },
  onDelete: "CASCADE",
});

Question.belongsToMany(User, { through: Answer, foreignKey: "question_id" });
User.belongsToMany(Question, { through: Answer, foreignKey: "user_id" });

User.belongsToMany(Survey, { through: "UserSurvey", foreignKey: "user_id" });
Survey.belongsToMany(User, { through: "UserSurvey", foreignKey: "survey_id" });

sequelize
  .sync()
  .then(() => {
    console.log("Tables created");
  })
  .catch((err) => {
    console.log(err);
  });

module.exports = { sequelize, models };
