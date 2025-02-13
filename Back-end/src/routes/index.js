const express = require("express");
const cors = require("cors");
const asyncHandler = require("../helpers/asyncHandler");
const QuestionController = require("../controllers/question.controller");
const SurveyController = require("../controllers/survey.controller");
const router = express.Router();

router.use(cors());

router.get("/test", (req, res) => {
  res.send("Hello World");
});

router.get("/all-questions", asyncHandler(QuestionController.getAllQuestion));
router.get("/all-surveys", asyncHandler(SurveyController.getAllSurvey));
router.post("/survey", asyncHandler(SurveyController.createSurvey));

module.exports = router;
