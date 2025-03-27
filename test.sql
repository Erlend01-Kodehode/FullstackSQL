DECLARE @ReturnStatus INT;
EXEC @ReturnStatus = sp_Register 
    @UserName = :username, 
    @Email = :email, 
    @Password = :password;
SELECT @ReturnStatus AS Status;

DECLARE @ReturnStatus INT;
DECLARE @Token varbinary(4000);
EXEC @ReturnStatus = sp_Login
    @UserName = :username,
    @Password = :password,
    @Token OUTPUT;
SELECT @ReturnStatus AS Status, @Token AS Token;

DECLARE @ReturnValue INT;
DECLARE @Token varbinary(4000);
EXEC @ReturnValue = sp_Edit
    @UserName = :username,
    @Email = :email,
    @Password = :password,
    @NewPassword = :newPassword,
    @Token OUTPUT;
SELECT @ReturnStatus AS Status, @Token AS Token;