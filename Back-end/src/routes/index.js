const express = require("express");
const cors = require("cors");
const asyncHandler = require("../helpers/asyncHandler");
const QuestionController = require("../controllers/question.controller");
const SurveyController = require("../controllers/survey.controller");
const { cascadeDeleteAllTables } = require("../models/index");
const router = express.Router();

router.use(cors());

router.get("/test", (req, res) => {
  res.send("Hello World");
});

router.use("/survey", require("./survey"));
router.use("/user", require("./user"));
router.use("/answer", require("./answer"));
router.use("/authentication", require("./authentication"));
router.use("/notification", require("./notification"));

router.get(
  "/reset-db",
  asyncHandler(async (req, res) => {
    await cascadeDeleteAllTables();
    res.status(200).json({ message: "Database reset successfully." });
  })
);

router.get("/all-questions", asyncHandler(QuestionController.getAllQuestion));

module.exports = router;
