const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/sequelize.config");
const SelectionAnswer = require("./SelectionAnswer");
const Option = require("./Option");
const Question = require("./Question");
const Survey = require("./Survey");
const User = require("./User");
const TextAnswer = require("./TextAnswer");
const RatingAnswer = require("./RatingAnswer");
const Notification = require("./Notification");
const UserNotification = require("./UserNotification");

// Array of models
const models = {
  User,
  Question,
  SelectionAnswer,
  Option,
  Survey,
  TextAnswer,
  RatingAnswer,
  Notification,
  UserNotification,
};

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

// Question.belongsToMany(User, {
//   through: SelectionAnswer,
//   foreignKey: "question_id",
// });
// User.belongsToMany(Question, {
//   through: SelectionAnswer,
//   foreignKey: "user_id",
// });

// Question.belongsToMany(User, {
//   through: TextAnswer,
//   foreignKey: "question_id",
// });
// User.belongsToMany(Question, {
//   through: TextAnswer,
//   foreignKey: "user_id",
// });

User.belongsToMany(Survey, { through: "UserSurvey", foreignKey: "user_id" });
Survey.belongsToMany(User, { through: "UserSurvey", foreignKey: "survey_id" });

UserNotification.belongsTo(User, { foreignKey: "user_id" });
UserNotification.belongsTo(Notification, { foreignKey: "notification_id" });
User.hasMany(UserNotification, { foreignKey: "user_id" });
Notification.hasMany(UserNotification, { foreignKey: "notification_id" });

sequelize
  .sync()
  .then(() => {
    console.log("Tables created");
  })
  .catch((err) => {
    console.log(err);
  });

/**
 * Cascade deletes all tables in the database by dropping them and re-syncing.
 * Use with caution: this will remove all data.
 */
async function cascadeDeleteAllTables() {
  try {
    // Drop all tables
    await sequelize.getQueryInterface().dropAllTables();
    // Recreate all tables
    await sequelize.sync();
    console.log("All tables dropped and recreated.");
  } catch (err) {
    console.error("Error during cascade delete:", err);
    throw err;
  }
}

module.exports = { sequelize, models, cascadeDeleteAllTables };
