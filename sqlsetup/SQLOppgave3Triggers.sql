/*
Erlend B. Ugelstad
Kristiansund
*/

use Oppgave3Fullstack
GO

drop trigger if exists tr_i_t_UserTokens_InsertLog
GO

create trigger tr_i_t_UserTokens_InsertLog
on t_UserTokens
after insert
as
begin
	begin try
		print 'InsertLog_Trigger_Start';

		declare @UserID bigint;

		declare c_tr_i_t_UserTokens_InsertLog cursor for
		select UserID
		from inserted;

		open c_tr_i_t_UserTokens_InsertLog;
		fetch next from c_tr_i_t_UserTokens_InsertLog into @UserID;

		while @@FETCH_STATUS = 0
			begin
				print 'InsertLog_Trigger_Insert_Start';
				insert into t_InsertLog (UserID, Type, Info) values (@UserID, 'Token', 'Generated User Token');
				print 'InsertLog_Trigger_Insert_Success';

				fetch next from c_tr_i_t_UserTokens_InsertLog into @UserID;
			end
		close c_tr_i_t_UserTokens_InsertLog;
		deallocate c_tr_i_t_UserTokens_InsertLog;

		print 'InsertLog_Trigger_Success';
	end try
	begin catch
		print 'ErrorLog_Trigger_Start';

		declare @UserErrorID bigint;

		declare c_tr_i_t_UserTokens_ErrorLog cursor for
		select UserID
		from inserted;

		open c_tr_i_t_UserTokens_ErrorLog;
		fetch next from c_tr_i_t_UserTokens_ErrorLog into @UserErrorID;

		while @@FETCH_STATUS = 0
			begin
				print 'ErrorLog_Trigger_Insert_Start';
				insert into t_ErrorLog (UserID, Type, Info) values (@UserErrorID, 'Token', 'Failure Generating User Token');
				print 'ErrorLog_Trigger_Insert_Success';

				fetch next from c_tr_i_t_UserTokens_ErrorLog into @UserErrorID;
			end
		close c_tr_i_t_UserTokens_ErrorLog;
		deallocate c_tr_i_t_UserTokens_ErrorLog;

		print 'ErrorLog_Trigger_Success';
	end catch
end
GO

drop trigger if exists tr_u_t_UserTokens_UpdateLog
GO

create trigger tr_u_t_UserTokens_UpdateLog
on t_UserTokens
after update
as
begin
	begin try
		print 'UpdateLog_Trigger_Start';

		declare @UserID bigint;

		declare c_tr_u_t_UserTokens_UpdateLog cursor for
		select UserID
		from inserted;

		open c_tr_u_t_UserTokens_UpdateLog;
		fetch next from c_tr_u_t_UserTokens_UpdateLog into @UserID;

		while @@FETCH_STATUS = 0
			begin
				print 'UpdateLog_Trigger_Update_Start';
				insert into t_UpdateLog (UserID, Type, Info) values (@UserID, 'Token', 'Updated User Token');
				print 'UpdateLog_Trigger_Update_Success';

				fetch next from c_tr_u_t_UserTokens_UpdateLog into @UserID;
			end
		close c_tr_u_t_UserTokens_UpdateLog;
		deallocate c_tr_u_t_UserTokens_UpdateLog;

		print 'UpdateLog_Trigger_Success';
	end try
	begin catch
		print 'ErrorLog_Trigger_Start';

		declare @UserErrorID bigint;

		declare c_tr_i_t_UserTokens_ErrorLog cursor for
		select UserID
		from inserted;

		open c_tr_i_t_UserTokens_ErrorLog;
		fetch next from c_tr_i_t_UserTokens_ErrorLog into @UserErrorID;

		while @@FETCH_STATUS = 0
			begin
				print 'ErrorLog_Trigger_Insert_Start';
				insert into t_ErrorLog (UserID, Type, Info) values (@UserErrorID, 'Token', 'Failure Updating User Token');
				print 'ErrorLog_Trigger_Insert_Success';

				fetch next from c_tr_i_t_UserTokens_ErrorLog into @UserErrorID;
			end
		close c_tr_i_t_UserTokens_ErrorLog;
		deallocate c_tr_i_t_UserTokens_ErrorLog;

		print 'ErrorLog_Trigger_Success';
	end catch
end
GO

select * from t_UserTokens

select * from t_InsertLog

select * from t_UpdateLog

update t_UserTokens set TokenValidDate = GETDATE() where UserID = 1