const User = require("../models/User");
const BaseService = require("./base.service");
const { BadRequestError } = require("../core/error.response");

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

  static async getUserById(userId) {
    const user = await User.findByPk(userId, {
      attributes: ["id", "name", "email", "point"],
    });
    return user;
  }

  static async updateUserPoints(userId, points) {
    const user = await User.findByPk(userId);
    if (!user) {
      throw new BadRequestError("User not found");
    }
    return await user.update({ point: points });
  }
}

module.exports = UserService;
