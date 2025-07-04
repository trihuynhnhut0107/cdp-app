const { OK, CREATED } = require("../core/success.response");
const AuthenticationService = require("../services/authentication.service");

class AuthenticationController {
  logIn = async (req, res, next) => {
    new OK({
      message: "Login successfully",
      metadata: await AuthenticationService.login(req.body),
    }).send(res);
  };
  signUp = async (req, res, next) => {
    new CREATED({
      message: "Signup successfully",
      metadata: await AuthenticationService.signUp(req.body),
    }).send(res);
  };
  refreshToken = async (req, res, next) => {
    new CREATED({
      message: "Access token refreshed",
      metadata: await AuthenticationService.refreshToken(req.body),
    }).send(res);
  };
}
module.exports = new AuthenticationController();
