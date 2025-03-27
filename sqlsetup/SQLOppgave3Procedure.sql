/*
Erlend B. Ugelstad
Kristiansund
*/

use Oppgave3Fullstack
GO

drop procedure if exists sp_Login
GO

create procedure sp_Login @UserName nvarchar(100), @Password nvarchar(100), @Token varbinary(4000) output
as
begin
	begin try
		--Declare Variables
		declare @UserID bigint;
		declare @Salt nvarchar(4000);
		declare @HashedPW varbinary(4000);
		declare @TMPToken nvarchar(4000);

		--Fetch Salt for PW decryption
		select @Salt = Salt
		from t_User
		where UserName = @UserName;

		--If Salt for user exists then proceed with login
		if @Salt is not null
			begin
				--Creates hash of input Password
				set @HashedPW = HASHBYTES('SHA2_512', @Password + @Salt);

				--Find UserID after comparing hashed password with already existing hash
				select @UserID = UserID
				from t_User
				where UserName = @UserName
				and Password = @HashedPW;

				--If user is found, create/update token
				if @UserID is null
					begin
						--Returns error value
						return -1;
					end
				else
					begin
						set @TMPToken = replace(newID(), '-', '') + replace(newID(), '-', '') + replace(newID(), '-', '') + replace(newID(), '-', '') + replace(newID(), '-', '');
						set @Token = HASHBYTES('SHA2_512', @TMPToken);

						--Clear space to reset token
						delete from t_UserTokens where UserID = @UserID;

						--Insert into Token table
						insert into t_UserTokens (UserID, Token, TokenValidDate) values (@UserID, @Token, DateAdd(minute, 60, getdate()));

						--Returns success value
						select @Token as Token, @UserName as Username, @HashedPW as HashedPW;
						return 0;
					end
			end
		else
			begin
				--Returns error value
				return -1;
			end
	end try
	begin catch
		begin
			return -1;
		end
	end catch
end;
GO

drop procedure if exists sp_Register;
GO

create procedure sp_Register @UserName nvarchar(100), @Email nvarchar(100), @Password nvarchar(100)
as
begin
	begin try
		--Declare Variables
		declare @Salt nvarchar(4000);
		declare @Seed nvarchar(4000);
		declare @HPassword varbinary(4000);

		--Create Salt using random seed
		set @Seed = replace(newID(), '-', '') + replace(newID(), '-', '') + replace(newID(), '-', '') + replace(newID(), '-', '') + replace(newID(), '-', '');
		set @Salt = HASHBYTES('SHA2_512', @Seed);

		--If data is provided, attempt user creation
		if @UserName is not null and @Email is not null and @Password is not null
			begin
				set @HPassword = HASHBYTES('SHA2_512', @Password + @Salt)
				insert into t_User (UserName, Email, Password, Salt)
				values
				(@UserName, @Email, @HPassword, @Salt);
				return 0;
			end
		else
			begin
				return -1;
			end
	end try
	begin catch
		begin
			return -1;
		end
	end catch
end;
GO

--Generate Test User
delete from t_User where UserName = 'TestUser1';
GO

exec sp_Register 'TestUser1', 'Test@Test.test', 'Password';
GO

--Attempt login with Test User
declare @Get varbinary(4000);
declare @ReturnStatus int;
declare @ExecLogin bigint;
exec @ExecLogin = sp_Login 'TestUser1', 'Password', @Get output;

select @ExecLogin

select * from t_User
GO

drop procedure if exists sp_Edit;
GO

create procedure sp_Edit @UserName nvarchar(100), @Email nvarchar(100), @Password nvarchar(100), @NewPassword nvarchar(100), @Token varbinary(4000) OUTPUT
as
begin
	begin try
		--Declare Variables
		declare @UserID bigint;
		declare @Salt nvarchar(4000);
		declare @HashedPW varbinary(4000);
		declare @TMPToken nvarchar(4000);
		declare @Seed nvarchar(4000);

		set @Seed = replace(newID(), '-', '') + replace(newID(), '-', '') + replace(newID(), '-', '') + replace(newID(), '-', '') + replace(newID(), '-', '');

		select @Salt = Salt
		from t_User
		where UserName = @UserName;

		if @Salt is not null
			begin
				--Compate Password with Hash
				set @HashedPW = HASHBYTES('SHA2_512', @Password + @Salt);

				select @UserID = UserID
				from t_User
				where UserName = @UserName
				and Password = @HashedPW;

				if @UserID is null
					begin
						--Return Failure
						return -1;
					end
				else
					begin
						set @TMPToken = replace(newID(), '-', '') + replace(newID(), '-', '') + replace(newID(), '-', '') + replace(newID(), '-', '') + replace(newID(), '-', '');
						set @Token = HASHBYTES('SHA2_512', @TMPToken);

						--Clear space to reset token
						delete from t_UserTokens where UserID = @UserID;

						--Insert into Token table
						insert into t_UserTokens (UserID, Token, TokenValidDate) values (@UserID, @Token, DateAdd(minute, 60, getdate()));

						--Generate new Salt
						set @Salt = HASHBYTES('SHA2_512', @Seed)

						--Set new Password
						set @HashedPW = HASHBYTES('SHA2_512', @NewPassword + @Salt)

						--Update User
						update t_User set Password = @HashedPW
						where UserID = @UserID

						--Return Procedure
						return 0;
					end
			end
		else
			begin
				--Return Failure
				return -1;
			end
	end try
	begin catch
		begin
			return -1;
		end
	end catch
end
GO

--Test Editing User
declare @ExecEdit bigint;
declare @Get varbinary(4000);

exec @ExecEdit = sp_Edit 'TestUser1', 'Test@Test.test', 'Password', 'NewPassword', @Get output

select @ExecEdit
GO