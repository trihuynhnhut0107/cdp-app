const Option = require("../models/Option");
const BaseService = require("./base.service");

class OptionService extends BaseService {
  static model = Option;
}

module.exports = OptionService;
