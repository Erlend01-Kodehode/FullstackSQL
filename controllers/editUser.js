import { Sequelize } from "sequelize";
import db from "../sequelize.js";

export const editUser = async (username, email, password, newPassword) => {
  const [editQuery] = await db.query(
    `
    DECLARE @ReturnValue INT;
    DECLARE @Token varbinary(4000);
    EXEC @ReturnValue = sp_Edit
        @UserName = :username,
        @Email = :email,
        @Password = :password,
        @NewPassword = :newPassword,
        @Token OUTPUT;
    SELECT @ReturnStatus AS Status, @Token AS Token;`,
    {
      replacements: { username, email, password, newPassword },
      type: Sequelize.QueryTypes.SELECT,
    }
  );
  return editQuery[0];
};
