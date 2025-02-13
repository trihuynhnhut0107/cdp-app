"use strict";

const Question = require("../models/Question");
const BaseService = require("./base.service");

class QuestionService extends BaseService {
  static model = Question;
}

module.exports = QuestionService;
