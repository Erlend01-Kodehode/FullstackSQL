use Oppgave3Fullstack
GO

drop trigger if exists tr_i_t_UserTokens_InsertLog
GO

create trigger tr_i_t_UserTokens_InsertLog
on t_UserTokens
after insert
as
begin
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
end
GO

drop trigger if exists tr_i_t_UserTokens_UpdateLog
GO

create trigger tr_i_t_UserTokens_UpdateLog
on t_UserTokens
after update
as
begin
	print 'UpdateLog_Trigger_Start';

	declare @UserID bigint;

	declare c_tr_i_t_UserTokens_UpdateLog cursor for
	select UserID
	from inserted;

	open c_tr_i_t_UserTokens_InsertLog;
	fetch next from c_tr_i_t_UserTokens_UpdateLog into @UserID;

	while @@FETCH_STATUS = 0
		begin
			print 'UpdateLog_Trigger_Update_Start';
			insert into t_InsertLog (UserID, Type, Info) values (@UserID, 'Token', 'Generated User Token');
			print 'UpdateLog_Trigger_Update_Success';

			fetch next from c_tr_i_t_UserTokens_UpdateLog into @UserID;
		end
	close c_tr_i_t_UserTokens_UpdateLog;
	deallocate c_tr_i_t_UserTokens_UpdateLog;

	print 'UpdateLog_Trigger_Success';
end
GO