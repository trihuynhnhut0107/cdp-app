const { ServerError, BadRequestError } = require("../core/error.response");
const SelectionAnswer = require("../models/SelectionAnswer");
const TextAnswer = require("../models/TextAnswer");
const BaseService = require("./base.service");
const Question = require("../models/Question");
const Option = require("../models/Option");
const User = require("../models/User");
const Survey = require("../models/Survey");
const { sequelize } = require("../config/sequelize.config");
const RatingAnswer = require("../models/RatingAnswer");

class AnswerService {
  static async validateBaseInputs({ question_id, user_id, transaction }) {
    if (!question_id || !user_id) {
      throw new BadRequestError("Please provide all required fields");
    }

    const [foundQuestion, foundUser] = await Promise.all([
      Question.findByPk(question_id, { transaction }),
      User.findByPk(user_id, { transaction }),
    ]);

    if (!foundQuestion) throw new BadRequestError("Invalid question_id");
    if (!foundUser) throw new BadRequestError("Invalid user_id");

    return foundQuestion;
  }

  static validateSelectionInput({ option_list, foundQuestion }) {
    if (!Array.isArray(option_list) || option_list.length === 0) {
      throw new BadRequestError("option_list is required");
    }

    // Ensure single option for selection type
    if (
      foundQuestion.question_type === "selection" &&
      option_list.length !== 1
    ) {
      throw new BadRequestError("Only one option allowed for selection type");
    }
  }

  static validateOpenInput({ answer }) {
    if (!answer) throw new BadRequestError("Answer is required");
  }

  static async createSelectionAnswer({
    question_id,
    option_list,
    user_id,
    transaction,
    question_type,
  }) {
    // For 'multiple', check per option; for 'selection', check once
    if (question_type === "selection") {
      const existingAnswers = await SelectionAnswer.findAll({
        where: { question_id, user_id },
        transaction,
      });
      if (existingAnswers.length > 0) {
        throw new BadRequestError("User has already answered this question");
      }
    }
    // Validate and create answers
    const createdAnswers = await Promise.all(
      option_list.map(async (option) => {
        const option_id = option.option_id;
        // For 'multiple', check per option
        if (question_type === "multiple") {
          const exists = await SelectionAnswer.findOne({
            where: { question_id, user_id, option_id },
            transaction,
          });
          if (exists) {
            throw new BadRequestError(
              `User has already selected this option for this question`
            );
          }
        }
        const foundOption = await Option.findByPk(option_id, { transaction });
        if (!foundOption) throw new BadRequestError("Invalid option_id");
        return SelectionAnswer.create(
          { question_id, option_id, user_id },
          { transaction }
        );
      })
    );
    return createdAnswers.map((a) => ({ id: a.id }));
  }

  static async createOpenAnswer({ question_id, user_id, answer, transaction }) {
    const createdAnswer = await TextAnswer.create(
      { question_id, user_id, answer },
      { transaction }
    );

    return { id: createdAnswer.id };
  }

  static async createRatingAnswer({
    question_id,
    user_id,
    score,
    transaction,
  }) {
    // Validate base inputs
    await this.validateBaseInputs({ question_id, user_id, transaction });
    // Check if user already answered this rating question
    const exists = await RatingAnswer.findOne({
      where: { question_id, user_id },
      transaction,
    });
    if (exists) {
      throw new BadRequestError("You have already answered this question");
    }
    // Validate score range (1-5)
    if (typeof score !== "number" || score < 1 || score > 5) {
      throw new BadRequestError("Score must be a number between 1 and 5");
    }
    const createdAnswer = await RatingAnswer.create(
      { question_id, user_id, score },
      { transaction }
    );
    return { id: createdAnswer.id };
  }

  static async createAnswer({
    question_id,
    option_list = [],
    user_id,
    answer,
    score,
    transaction,
  }) {
    const foundQuestion = await this.validateBaseInputs({
      question_id,
      user_id,
      transaction,
    });
    // Only check for existing answer for 'selection', 'open', and 'rating' types
    if (foundQuestion.question_type === "selection") {
      const exists = await SelectionAnswer.findOne({
        where: { question_id, user_id },
        transaction,
      });
      if (exists) {
        throw new BadRequestError("You have already answered this question");
      }
    }
    if (foundQuestion.question_type === "open") {
      const exists = await TextAnswer.findOne({
        where: { question_id, user_id },
        transaction,
      });
      if (exists) {
        throw new BadRequestError("You have already answered this question");
      }
    }
    if (foundQuestion.question_type === "rating") {
      const exists = await RatingAnswer.findOne({
        where: { question_id, user_id },
        transaction,
      });
      if (exists) {
        throw new BadRequestError("You have already answered this question");
      }
    }
    try {
      if (
        foundQuestion.question_type === "selection" ||
        foundQuestion.question_type === "multiple"
      ) {
        this.validateSelectionInput({ option_list, foundQuestion });
        return await this.createSelectionAnswer({
          question_id,
          option_list,
          user_id,
          transaction,
          question_type: foundQuestion.question_type,
        });
      }
      if (foundQuestion.question_type === "open") {
        this.validateOpenInput({ answer });
        return await this.createOpenAnswer({
          question_id,
          user_id,
          answer,
          transaction,
        });
      }
      if (foundQuestion.question_type === "rating") {
        return await this.createRatingAnswer({
          question_id,
          user_id,
          score,
          transaction,
        });
      }
      throw new BadRequestError("Invalid question type");
    } catch (error) {
      console.error("Error during createAnswer:", error);
      throw error; // Ensure the transaction is rolled back
    }
  }

  static async answerSurvey({ survey_id, user_id, answers }) {
    if (!Array.isArray(answers)) {
      throw new BadRequestError("Answers must be an array");
    }

    const transaction = await sequelize.transaction();

    try {
      // Check if user has already completed this survey
      const survey = await Survey.findByPk(survey_id, { transaction });
      if (!survey) {
        throw new BadRequestError("Survey not found");
      }

      const user = await User.findByPk(user_id, { transaction });
      if (!user) {
        throw new BadRequestError("User not found");
      }

      // Check if user has already answered this survey
      const existingUserSurvey = await user.getSurveys({
        where: { id: survey_id },
        transaction,
      });

      if (existingUserSurvey.length > 0) {
        throw new BadRequestError("User has already completed this survey");
      }

      const createdAnswers = await Promise.all(
        answers.map(async (answer) => {
          return await this.createAnswer({
            ...answer,
            user_id,
            transaction,
          });
        })
      );

      // Add user to survey and award points
      await survey.addUser(user_id, { transaction });

      // Award points to user
      await user.increment("point", {
        by: survey.point,
        transaction,
      });

      await transaction.commit();
      return createdAnswers;
    } catch (error) {
      await transaction.rollback();
      console.error("Database error:", error);
      // Return the error message in the thrown ServerError for debugging
      throw new ServerError(`Failed to create answers: ${error.message}`);
    }
  }
  static async findExistingAnswer({ question_id, user_id }) {
    const existingAnswer = await SelectionAnswer.findAll({
      where: {
        question_id,
        user_id,
      },
    });
    if (existingAnswer.length > 0) {
      return true;
    }
    return false;
  }

  static getAnswerBySurveyId = async (survey_id, user_id) => {
    const surveyName = await Survey.findOne({
      where: {
        id: survey_id,
      },
      attributes: ["survey_name"],
    });

    if (!surveyName) {
      throw new BadRequestError("Survey not found");
    }

    const questions = await Question.findAll({
      where: {
        survey_id: survey_id,
      },
    });
    const questionList = await Promise.all(
      questions.map(async (question) => {
        if (question.question_type === "open") {
          const answerList = await TextAnswer.findAll({
            where: {
              question_id: question.id,
              user_id: user_id,
            },
            attributes: ["answer"],
          });
          return {
            question: question.question_content,
            answer: answerList,
          };
        } else if (
          question.question_type === "selection" ||
          question.question_type === "multiple"
        ) {
          const answerIdList = await SelectionAnswer.findAll({
            where: {
              question_id: question.id,
              user_id: user_id,
            },
            attributes: ["option_id"],
          });
          const answerList = await Promise.all(
            answerIdList.map(async (answerObj) => {
              const answerContent = await Option.findOne({
                where: {
                  id: answerObj.option_id,
                },
                attributes: ["option_content"],
              });
              return answerContent;
            })
          );
          return {
            question: question.question_content,
            answer: answerList,
          };
        } else if (question.question_type === "rating") {
          const ratingAnswer = await RatingAnswer.findOne({
            where: {
              question_id: question.id,
              user_id: user_id,
            },
            attributes: ["score"],
          });
          return {
            question: question.question_content,
            answer: ratingAnswer ? ratingAnswer.score : null,
          };
        }
      })
    );

    return {
      survey_name: surveyName,
      questions: questionList,
    };
  };
}

module.exports = AnswerService;
