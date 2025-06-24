const User = require("../models/User");
const BaseService = require("./base.service");

class UserService extends BaseService {
  static model = User;

  static async createUser({ name, email, password }) {
    const user = await User.create({
      name,
      email,
      password,
    });
    return user;
  }
}

module.exports = UserService;
