import { Sequelize } from "sequelize";
import db from "../sequelize.js";

export const loginUser = async (username, password) => {
  const [loginQuery] = await db.query(
    `   
    DECLARE @ReturnStatus INT;
    DECLARE @Token varbinary(4000);
    EXEC @ReturnStatus = sp_Login
        @UserName = :username,
        @Password = :password,
        @Token OUTPUT;
    SELECT @ReturnStatus AS Status, @Token AS Token;`,
    {
      replacements: { username, password },
      type: Sequelize.QueryTypes.SELECT,
    }
  );
  return loginQuery[0];
};
