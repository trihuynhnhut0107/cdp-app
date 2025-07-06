const express = require("express");
const asyncHandler = require("../helpers/asyncHandler");
const answerController = require("../controllers/answer.controller");

const router = express.Router();

router.post("/", asyncHandler(answerController.createAnswers));
router.get("/", asyncHandler(answerController.getAnswerBySurveyId));
router.get(
  "/survey/:survey_id",
  asyncHandler(answerController.getAllAnswersForSurvey)
);

module.exports = router;
