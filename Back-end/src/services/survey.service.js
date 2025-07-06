"use strict";

const Option = require("../models/Option");
const Question = require("../models/Question");
const Survey = require("../models/Survey");
const { UserSurvey } = require("../models").sequelize.models;
const { BadRequestError } = require("../core/error.response");
const BaseService = require("./base.service");
const { where } = require("sequelize");
const NotificationService = require("./notification.service");

class SurveyService extends BaseService {
  static model = Survey;

  static async getAllSurveys(userId) {
    if (!userId) {
      // Return all surveys (including disabled ones) with disabled field
      const surveys = await Survey.findAll();
      return surveys.map((survey) => survey.toJSON());
    }

    // Return only non-disabled surveys with answered status
    const surveys = await Survey.findAll({ where: { disabled: false } });
    const surveysWithStatus = await Promise.all(
      surveys.map(async (survey) => {
        const answered = await UserSurvey.findOne({
          where: {
            user_id: userId,
            survey_id: survey.id,
          },
        });
        return {
          ...survey.toJSON(),
          answered: !!answered,
        };
      })
    );
    return surveysWithStatus;
  }

  static async getSurveyByUUID(uuid) {
    const survey = await Survey.findByPk(uuid);
    if (!survey) {
      throw new BadRequestError("Survey not found");
    }
    const questions = await Question.findAll({
      where: { survey_id: survey.id },
    });
    const questionsOption = await Promise.all(
      questions.map(async (question) => {
        const options = await Option.findAll({
          where: { question_id: question.id },
          attributes: ["id", "option_content"],
        });
        return {
          question: {
            id: question.id,
            question_content: question.question_content,
            options_quantity: question.options_quantity,
            question_type: question.question_type,
          },
          options,
        };
      })
    );
    return {
      survey: {
        id: survey.id,
        survey_name: survey.survey_name,
        question_quantity: survey.question_quantity,
        point: survey.point,
        disabled: survey.disabled,
      },
      questions: questionsOption,
    };
  }

  static async disableSurvey(uuid) {
    const survey = await Survey.findByPk(uuid);
    if (!survey) {
      throw new BadRequestError("Survey not found");
    }

    survey.disabled = true;
    await survey.save();

    return {
      id: survey.id,
      survey_name: survey.survey_name,
      question_quantity: survey.question_quantity,
      point: survey.point,
      disabled: survey.disabled,
    };
  }

  static async createData({ survey_name, questions, point = 0 }) {
    if (!Array.isArray(questions)) {
      throw new BadRequestError("Questions must be an array");
    }
    const survey = await Survey.create({
      survey_name: survey_name,
      question_quantity: questions.length,
      point: point,
    });

    // Create all questions in parallel
    const createdQuestions = await Promise.all(
      questions.map(async (question) => {
        const createdQuestion = await survey.createQuestion({
          question_content: question.question_content,
          options_quantity: question.options?.length || 1,
          question_type: question.question_type,
        });
        if (!createdQuestion)
          throw new BadRequestError("Create question failed");

        if (
          createdQuestion.question_type === "selection" ||
          createdQuestion.question_type === "multiple"
        ) {
          const createdOptions = await Promise.all(
            question.options.map(async (option) => {
              const createdOption = await createdQuestion.createOption({
                option_content: option.option_content,
              });
              if (!createdOption)
                throw new BadRequestError("Create option failed");
              return createdOption;
            })
          );
        }
        return createdQuestion;
      })
    );

    // Add notification after survey creation
    await NotificationService.createNotificationForNewSurvey(survey.id);

    return { surveyData: survey, questionsData: createdQuestions };
  }
}

module.exports = SurveyService;
