const express = require("express");
const surveyController = require("../controllers/survey.controller");
const asyncHandler = require("../helpers/asyncHandler");

const router = express.Router();

router.get("/", asyncHandler(surveyController.getAllSurvey));
router.post("/", asyncHandler(surveyController.createSurvey));
router.get("/:uuid", asyncHandler(surveyController.getSurveyByUUID));
router.patch("/:uuid/disable", asyncHandler(surveyController.disableSurvey));

module.exports = router;
