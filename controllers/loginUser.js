import { Sequelize } from "sequelize";
import db from "../sequelize.js";

export const loginUser = async (username, password) => {
  const [loginQuery] = await db.query(
    `   
    DECLARE @ReturnStatus INT;
    DECLARE @Get varbinary(4000);
    EXEC @ReturnStatus = sp_Login
        @UserName = :username,
        @Password = :password,
        @Get OUTPUT;
    SELECT @ReturnStatus AS Status, @Get AS Token;`,
    {
      replacements: { username, password },
      type: Sequelize.QueryTypes.SELECT,
    }
  );
  console.log(loginQuery);
  return loginQuery[0];
};
