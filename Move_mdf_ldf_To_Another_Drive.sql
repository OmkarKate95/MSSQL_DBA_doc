-- First use database you want move mdf and ldf
	USE Amazon

-- Get mdf and ldf file location path
	SELECT * FROM sys.sysfiles

--Set master databse 
	USE Master

-- Set databse in offline state
	ALTER DATABASE Amazon SET OFFLINE

-- Change the file location inside SQL Server
	ALTER DATABASE Amazon 
	MODIFY FILE (NAME = Amazon, FILENAME = 'E:\SQL Instance\SQL01\Data\Amazon.mdf')

	ALTER DATABASE Amazon 
	MODIFY FILE (NAME = Amazon_log, FILENAME = 'E:\SQL Instance\SQL01\Data\Amazon_log.ldf')

-- Set databse on online state
	ALTER DATABASE Amazon SET ONLINE
	
-- Check the database file location
	SELECT name, physical_name 
	FROM sys.master_files 
	WHERE database_id = DB_ID('Amazon');


Amazon		C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Amazon.mdf
Amazon_log	C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Amazon_log.ldf





