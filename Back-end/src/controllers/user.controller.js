const { OK, CREATED } = require("../core/success.response");
const UserService = require("../services/user.service");

class UserController {
  createUser = async (req, res, next) => {
    new CREATED({
      message: "User created successfully",
      metadata: await UserService.createUser(req.body),
    }).send(res);
  };

  getUserById = async (req, res, next) => {
    const { id } = req.params;
    new OK({
      message: "User retrieved successfully",
      metadata: await UserService.getUserById(id),
    }).send(res);
  };
}

module.exports = new UserController();
