
-- Execute the following statements at the Primary to configure Log Shipping 
-- for the database [LAPTOP-U9ABQG76].[Onkar],
-- The script needs to be run at the Primary in the context of the [msdb] database.  
------------------------------------------------------------------------------------- 
-- Adding the Log Shipping configuration 

-- ****** Begin: Script to be run at Primary: [LAPTOP-U9ABQG76] ******


	DECLARE @LS_BackupJobId	AS uniqueidentifier 
	DECLARE @LS_PrimaryId	AS uniqueidentifier 
	DECLARE @SP_Add_RetCode	As int 


	EXEC @SP_Add_RetCode = master.dbo.sp_add_log_shipping_primary_database 
			@database = N'Onkar' 
			,@backup_directory = N'\\LAPTOP-U9ABQG76\Primary_Onkar' 
			,@backup_share = N'\\LAPTOP-U9ABQG76\Primary_Onkar' 
			,@backup_job_name = N'LSBackup_Onkar' 
			,@backup_retention_period = 4320
			,@backup_compression = 2
			,@backup_threshold = 60 
			,@threshold_alert_enabled = 1
			,@history_retention_period = 5760 
			,@backup_job_id = @LS_BackupJobId OUTPUT 
			,@primary_id = @LS_PrimaryId OUTPUT 
			,@overwrite = 1 


	IF (@@ERROR = 0 AND @SP_Add_RetCode = 0) 
	BEGIN 

	DECLARE @LS_BackUpScheduleUID	As uniqueidentifier 
	DECLARE @LS_BackUpScheduleID	AS int 


	EXEC msdb.dbo.sp_add_schedule 
			@schedule_name =N'LSBackupSchedule_LAPTOP-U9ABQG761' 
			,@enabled = 1 
			,@freq_type = 4 
			,@freq_interval = 1 
			,@freq_subday_type = 4 
			,@freq_subday_interval = 15 
			,@freq_recurrence_factor = 0 
			,@active_start_date = 20250726 
			,@active_end_date = 99991231 
			,@active_start_time = 0 
			,@active_end_time = 235900 
			,@schedule_uid = @LS_BackUpScheduleUID OUTPUT 
			,@schedule_id = @LS_BackUpScheduleID OUTPUT 

	EXEC msdb.dbo.sp_attach_schedule 
			@job_id = @LS_BackupJobId 
			,@schedule_id = @LS_BackUpScheduleID  

	EXEC msdb.dbo.sp_update_job 
			@job_id = @LS_BackupJobId 
			,@enabled = 1 


	END 


	EXEC master.dbo.sp_add_log_shipping_alert_job 

	EXEC master.dbo.sp_add_log_shipping_primary_secondary 
			@primary_database = N'Onkar' 
			,@secondary_server = N'LAPTOP-U9ABQG76\SQL01' 
			,@secondary_database = N'Onkar' 
			,@overwrite = 1 

-- ****** End: Script to be run at Primary: [LAPTOP-U9ABQG76]  ******


-- Execute the following statements at the Secondary to configure Log Shipping 
-- for the database [LAPTOP-U9ABQG76\SQL01].[Onkar],
-- the script needs to be run at the Secondary in the context of the [msdb] database. 
------------------------------------------------------------------------------------- 
-- Adding the Log Shipping configuration 

-- ****** Begin: Script to be run at Secondary: [LAPTOP-U9ABQG76\SQL01] ******


	DECLARE @LS_Secondary__CopyJobId	AS uniqueidentifier 
	DECLARE @LS_Secondary__RestoreJobId	AS uniqueidentifier 
	DECLARE @LS_Secondary__SecondaryId	AS uniqueidentifier 
	DECLARE @LS_Add_RetCode	As int 


	EXEC @LS_Add_RetCode = master.dbo.sp_add_log_shipping_secondary_primary 
			@primary_server = N'LAPTOP-U9ABQG76' 
			,@primary_database = N'Onkar' 
			,@backup_source_directory = N'\\LAPTOP-U9ABQG76\Primary_Onkar' 
			,@backup_destination_directory = N'\\LAPTOP-U9ABQG76\Secondary_Onkar' 
			,@copy_job_name = N'LSCopy_LAPTOP-U9ABQG76_Onkar' 
			,@restore_job_name = N'LSRestore_LAPTOP-U9ABQG76_Onkar' 
			,@file_retention_period = 4320 
			,@overwrite = 1 
			,@copy_job_id = @LS_Secondary__CopyJobId OUTPUT 
			,@restore_job_id = @LS_Secondary__RestoreJobId OUTPUT 
			,@secondary_id = @LS_Secondary__SecondaryId OUTPUT 

	IF (@@ERROR = 0 AND @LS_Add_RetCode = 0) 
	BEGIN 

	DECLARE @LS_SecondaryCopyJobScheduleUID	As uniqueidentifier 
	DECLARE @LS_SecondaryCopyJobScheduleID	AS int 


	EXEC msdb.dbo.sp_add_schedule 
			@schedule_name =N'DefaultCopyJobSchedule' 
			,@enabled = 1 
			,@freq_type = 4 
			,@freq_interval = 1 
			,@freq_subday_type = 4 
			,@freq_subday_interval = 15 
			,@freq_recurrence_factor = 0 
			,@active_start_date = 20250726 
			,@active_end_date = 99991231 
			,@active_start_time = 0 
			,@active_end_time = 235900 
			,@schedule_uid = @LS_SecondaryCopyJobScheduleUID OUTPUT 
			,@schedule_id = @LS_SecondaryCopyJobScheduleID OUTPUT 

	EXEC msdb.dbo.sp_attach_schedule 
			@job_id = @LS_Secondary__CopyJobId 
			,@schedule_id = @LS_SecondaryCopyJobScheduleID  

	DECLARE @LS_SecondaryRestoreJobScheduleUID	As uniqueidentifier 
	DECLARE @LS_SecondaryRestoreJobScheduleID	AS int 


	EXEC msdb.dbo.sp_add_schedule 
			@schedule_name =N'DefaultRestoreJobSchedule' 
			,@enabled = 1 
			,@freq_type = 4 
			,@freq_interval = 1 
			,@freq_subday_type = 4 
			,@freq_subday_interval = 15 
			,@freq_recurrence_factor = 0 
			,@active_start_date = 20250726 
			,@active_end_date = 99991231 
			,@active_start_time = 0 
			,@active_end_time = 235900 
			,@schedule_uid = @LS_SecondaryRestoreJobScheduleUID OUTPUT 
			,@schedule_id = @LS_SecondaryRestoreJobScheduleID OUTPUT 

	EXEC msdb.dbo.sp_attach_schedule 
			@job_id = @LS_Secondary__RestoreJobId 
			,@schedule_id = @LS_SecondaryRestoreJobScheduleID  


	END 


	DECLARE @LS_Add_RetCode2	As int 


	IF (@@ERROR = 0 AND @LS_Add_RetCode = 0) 
	BEGIN 

	EXEC @LS_Add_RetCode2 = master.dbo.sp_add_log_shipping_secondary_database 
			@secondary_database = N'Onkar' 
			,@primary_server = N'LAPTOP-U9ABQG76' 
			,@primary_database = N'Onkar' 
			,@restore_delay = 0 
			,@restore_mode = 1 
			,@disconnect_users	= 1 
			,@restore_threshold = 45   
			,@threshold_alert_enabled = 1 
			,@history_retention_period	= 5760 
			,@overwrite = 1 

	END 


	IF (@@error = 0 AND @LS_Add_RetCode = 0) 
	BEGIN 

	EXEC msdb.dbo.sp_update_job 
			@job_id = @LS_Secondary__CopyJobId 
			,@enabled = 1 

	EXEC msdb.dbo.sp_update_job 
			@job_id = @LS_Secondary__RestoreJobId 
			,@enabled = 1 

	END 


-- ****** End: Script to be run at Secondary: [LAPTOP-U9ABQG76\SQL01] ******


