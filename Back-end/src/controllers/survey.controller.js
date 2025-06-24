"use strict";
const { validate: isUUID } = require("uuid");

const { OK, CREATED } = require("../core/success.response");
const SurveyService = require("../services/survey.service");
const { BadRequestError } = require("../core/error.response");
const NotificationService = require("../services/notification.service");

class SurveyController {
  getAllSurvey = async (req, res, next) => {
    new OK({
      message: "Get all survey successfully",
      metadata: await SurveyService.getAllSurveys(req.headers.user_id),
    }).send(res);
  };
  getSurveyByUUID = async (req, res, next) => {
    if (!isUUID(req.params.uuid)) {
      throw new BadRequestError("Invalid UUID");
    }
    new OK({
      message: "Get survey by UUID successfully",
      metadata: await SurveyService.getSurveyByUUID(req.params.uuid),
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
