"use strict";

const { OK } = require("../core/success.response");
const QuestionService = require("../services/question.service");

class QuestionController {
  getAllQuestion = async (req, res, next) => {
    new OK({
      message: "Get all question successfully",
      metadata: await QuestionService.findAll(),
    }).send(res);
  };
}

module.exports = new QuestionController();
