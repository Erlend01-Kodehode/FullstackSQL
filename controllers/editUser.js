import { Sequelize } from "sequelize";
import db from "../sequelize.js";

export const editUser = async (username, email, password, newPassword) => {
  const [editQuery] = await db.query();
  return editQuery[0];
};
