-- Mirror Server
--  Create the Same Database Name on Mirror
	CREATE DATABASE Iphone;
-----------------------------------------------------------------------------------------------------------------

-- Check the database files and paths
	EXEC sp_helpdb Iphone;
-----------------------------------------------------------------------------------------------------------------	

-- Restore full backup with file moves and NORECOVERY 

	RESTORE DATABASE Iphone
	FROM DISK = 'D:\SSMS\Backup\full_Iphone.bak'
	WITH 
		MOVE 'Iphone' TO 'E:\SQL01\DATA\Iphone.mdf',
		MOVE 'Iphone_log' TO 'E:\SQL01\LOG\Iphone_log.ldf',
		REPLACE,
		NORECOVERY;
	
-- Restore tlog backup with norecovery option

	RESTORE LOG Iphone
	FROM DISK = 'D:\SSMS\Backup\tlog_Iphone.trn'
	WITH NORECOVERY;
-----------------------------------------------------------------------------------------------------------------

-- First need to restore full and diffrential database on mirror server with norecovery option
-- HANDSHAKE METHOD FROM PRIMARY TO MIRROR SERVER
-- Configure mirroring through Script

	ALTER DATABASE Iphone
	SET PARTNER = 'TCP://LAPTOP-U9ABQG76:5022';  -- Replace with actual primary server name and endpoint port
-----------------------------------------------------------------------------------------------------------------

-- Safety FULL with Witness :
-- Well the answer for this  depends on the mode in which mirroring is configured.
-- If mirroring is configured in High Availability mode (Full safety) then we don t
-- need to worry about failover as the mirror server will form a quorum with witness 
-- and will initiate an automatic failover. The safety level can be set using the below command,

-- Enables automatic failover if a witness server is present

	ALTER DATABASE Iphone SET SAFETY FULL;

--  Safety OFF — High Performance Mode, asynchronous mirroring

	ALTER DATABASE Iphone SET SAFETY OFF;
-----------------------------------------------------------------------------------------------------------------
-- Safety OFF :
-- For example, prior to the failure, Server_A and Server_B acted as principal and mirror respectively.
-- Server_A fails. You need to execute the following on Server_B to make the database service available.

-- In case of Principal failure, to force failover on Mirror:

	ALTER DATABASE Iphone SET PARTNER FORCE_SERVICE_ALLOW_DATA_LOSS;
-----------------------------------------------------------------------------------------------------------------

-- Safety FULL without Witness :
-- This scenario provides high safety, but automatic failover is not allowed.
-- This mode is called as High Protection mode. In the event of failure of the 
-- principal, the database service becomes unavailable. 
-- You need manual intervention to make the database service available. 
-- You must break the mirroring session and then recover the mirror database.

--**For example, prior to the failure,Server_A and Server_B acted as principal
--  and mirror respectively. Server_A fails.You need to execute
--  the following on Server_B to make the database service available:**

-- Break mirroring and recover manually on Mirror

	ALTER DATABASE Iphone SET PARTNER OFF;
	RESTORE DATABASE Iphone WITH RECOVERY;
-----------------------------------------------------------------------------------------------------------------
