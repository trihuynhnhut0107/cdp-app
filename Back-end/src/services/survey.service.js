"use strict";

const Option = require("../models/Option");
const Question = require("../models/Question");
const Survey = require("../models/Survey");
const { BadRequestError } = require("../core/error.response");
const BaseService = require("./base.service");

class SurveyService extends BaseService {
  static model = Survey;

  static async getSurveyByUUID(uuid) {
    const foundSurvey = await this.findByUUID(uuid);
    if (!foundSurvey) throw new Error("Survey not found");

    const foundQuestions = await Question.findAll({
      where: { survey_id: foundSurvey.id },
    });

    for (const question of foundQuestions) {
      question.options = await Option.findAll({
        where: { question_id: question.id },
      });
    }
    return foundQuestions;
  }
  static async createData({ survey_name, questions }) {
    if (!Array.isArray(questions)) {
      throw new BadRequestError("Questions must be an array");
    }
    const survey = await Survey.create({
      survey_name: survey_name,
      question_quantity: questions.length,
    });

    // Create all questions in parallel
    const createdQuestions = await Promise.all(
      questions.map(async (question) => {
        const createdQuestion = await survey.createQuestion({
          question_content: question.question_content,
          options_quantity: question.options.length,
        });
        if (!createdQuestion)
          throw new BadRequestError("Create question failed");

        // Create all options for this question in parallel
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

        return createdQuestion;
      })
    );
    return survey;
  }
}

module.exports = SurveyService;
