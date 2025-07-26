-- Primary Server
-- Create the Database on the Primary Server
	CREATE DATABASE Iphone;
------------------------------------------------------------------------------------	

-- Take Full Backup and Log Backup of the Primary Database
-- These backups will be restored on the Mirror server (WITH NORECOVERY)

-- Full backup
	BACKUP DATABASE Iphone  
	TO DISK = 'D:\SSMS\Backup\full_Iphone.bak';  
	

-- Transaction log backup
	BACKUP LOG Iphone  
	TO DISK = 'D:\SSMS\Backup\tlog_Iphone.trn';  
------------------------------------------------------------------------------------

-- Establish Mirroring Handshake (After setting up mirror side)
-- This command connects the Primary to the Mirror server endpoint

	ALTER DATABASE Iphone  
	SET PARTNER = 'TCP://LAPTOP-U9ABQG76/SQL01:5023';  
------------------------------------------------------------------------------------
