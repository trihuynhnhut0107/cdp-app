const { OK, CREATED } = require("../core/success.response");
const UserService = require("../services/user.service");

class UserController {
  createUser = async (req, res, next) => {
    new CREATED({
      message: "User created successfully",
      metadata: await UserService.createUser(req.body),
    }).send(res);
  };
}

module.exports = new UserController();
