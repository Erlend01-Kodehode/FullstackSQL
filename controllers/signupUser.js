import { Sequelize } from "sequelize";
import db from "../sequelize.js";

export const signupUser = async (username, email, password) => {
  const [signupQuery] = await db.query(
    `
    DECLARE @ReturnStatus INT;
    EXEC @ReturnStatus = sp_Register 
        @UserName = :username, 
        @Email = :email, 
        @Password = :password;
    SELECT @ReturnStatus AS Status;`,
    {
      replacements: { username, email, password },
      type: Sequelize.QueryTypes.SELECT,
    }
  );
  return signupQuery[0];
};
