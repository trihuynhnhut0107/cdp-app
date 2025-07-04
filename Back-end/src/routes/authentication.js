const express = require("express");
const asyncHandler = require("../helpers/asyncHandler");
const authenticationController = require("../controllers/authentication.controller");
const router = express.Router();

router.post("/login", asyncHandler(authenticationController.logIn));
router.post("/signup", asyncHandler(authenticationController.signUp));
router.post(
  "/refresh-token",
  asyncHandler(authenticationController.refreshToken)
);

module.exports = router;
