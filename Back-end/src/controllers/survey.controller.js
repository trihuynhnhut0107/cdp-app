"use strict";
const { validate: isUUID } = require("uuid");

const { OK, CREATED } = require("../core/success.response");
const SurveyService = require("../services/survey.service");
const { BadRequestError } = require("../core/error.response");

class SurveyController {
  getAllSurvey = async (req, res, next) => {
    new OK({
      message: "Get all survey successfully",
      metadata: await SurveyService.findAll(),
    }).send(res);
  };
  createSurvey = async (req, res, next) => {
    new CREATED({
      message: "Created survey successfully",
      metadata: await SurveyService.createData(req.body),
    }).send(res);
  };
}
module.exports = new SurveyController();
