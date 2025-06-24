const { BadRequestError } = require("../core/error.response");
const User = require("../models/User");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const {
  generateAccessToken,
  generateRefreshToken,
} = require("./jwtToken.service");

class AuthenticationService {
  static async login({ email, password }) {
    if (!email || !password) {
      throw new BadRequestError("Email and password are required");
    }
    const foundUser = await User.findOne({ where: { email } });
    if (!foundUser) {
      throw new BadRequestError("User does not exist");
    }
    const passwordVerify = await bcrypt.compare(password, foundUser.password);
    if (!passwordVerify) {
      throw new BadRequestError("Incorrect password");
    }
    const payload = { id: foundUser.id, email: foundUser.email };
    const accessToken = generateAccessToken(payload);
    const refreshToken = generateRefreshToken(payload);

    return { user: foundUser, accessToken, refreshToken };
  }

  static async signUp({ name, email, password }) {
    if (!name || !email || !password) {
      throw new BadRequestError("All fields are required");
    }
    const foundUser = await User.findOne({ where: { email } });
    if (foundUser) {
      throw new BadRequestError("User already exists");
    }
    const cryptedPassword = await bcrypt.hash(password, 10);
    const user = await User.create({
      name,
      email,
      password: cryptedPassword,
    });
    return user;
  }
  static async refreshToken({ refreshToken }) {
    if (!refreshToken) {
      throw new BadRequestError("Refresh token is required");
    }
    const decoded = jwt.verify(refreshToken, process.env.JWT_REFRESH_SECRET);
    console.log("refreshToken -> decoded", decoded);
    const payload = { id: decoded.id, email: decoded.email };
    const accessToken = generateAccessToken(payload);
    return { accessToken };
  }
}

module.exports = AuthenticationService;
