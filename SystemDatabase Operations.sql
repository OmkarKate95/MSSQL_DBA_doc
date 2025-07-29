-- Show advanced configuration details
	EXEC sp_configure 'show advanced options', 1;
	GO
	RECONFIGURE;
	GO

-- Set database SINGLE_USER / MULTI_USER 
	ALTER DATABASE PerfDB SET MULTI_USER;

-- Get full details of all databases
	SELECT * FROM sys.databases;
	SELECT * FROM sys.sysdatabases;

-- Get all objects in current database 
	SELECT * FROM sys.sysobjects;

-- Get list of all user tables
	SELECT * FROM sys.tables;

-- Shutdown SQL Server instance (use with caution!)
	SHUTDOW-N

-- Get SQL logins details
	SELECT * FROM sys.syslogins;

-- Get SQL Server resource version 
	SELECT SERVERPROPERTY('ResourceVersion');
	GO

-- Review backup media details
	SELECT * FROM dbo.backupmediafamily;

-- View SQL Agent jobs
	SELECT * FROM sysjobs;

-- View SQL Agent operators 
	SELECT * FROM sysoperators;

-- View Database Mail profiles
	SELECT * FROM dbo.sysmail_profile;

-- Create and test a **local temporary table** (#temp) - session scoped
	CREATE TABLE #temp (id INT);
	INSERT INTO #temp VALUES (2);
	SELECT * FROM #temp;
-- Temporary storage during a session or procedure.

-- Create and test a **global temporary table** (##temp) - visible to all sessions
	CREATE TABLE ##temp (id INT);
	INSERT INTO ##temp VALUES (2);
	GO
	SELECT * FROM ##temp;
-- Temporary data sharing across sessions
