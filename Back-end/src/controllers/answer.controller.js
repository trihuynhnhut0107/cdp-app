const { CREATED } = require("../core/success.response");
const AnswerService = require("../services/answer.service");

class AnswerController {
  createAnswers = async (req, res, next) => {
    console.log("Full body:::", req.body);
    new CREATED({
      message: "Answers created successfully",
      metadata: await AnswerService.answerSurvey(req.body),
    }).send(res);
  };
  getAnswerBySurveyId = async (req, res, next) => {
    const { survey_id, user_id } = req.query;
    new CREATED({
      message: "Answers retrieved successfully",
      metadata: await AnswerService.getAnswerBySurveyId(survey_id, user_id),
    }).send(res);
  };
}

module.exports = new AnswerController();
