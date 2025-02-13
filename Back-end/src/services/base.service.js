"use strict";
class BaseService {
  static model;
  static async findAll(option = {}) {
    return this.model.findAll(option);
  }
  static async findByUUID(uuid, options = {}) {
    return this.model.findByPK(uuid, options);
  }
  static async createData(data) {
    return this.model.create(data);
  }
  static async update(uuid, data) {
    const record = await this.model.findByPk(uuid);
    if (!record) throw new Error("Record not found");
    return await record.update(data);
  }
}
module.exports = BaseService;
