const express = require("express");
const asyncHandler = require("../helpers/asyncHandler");
const userController = require("../controllers/user.controller");

const router = express.Router();

router.post("/", asyncHandler(userController.createUser));
router.get("/:id", asyncHandler(userController.getUserById));

module.exports = router;
