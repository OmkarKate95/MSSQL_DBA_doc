-- Check Current SQL Server Agent Jobs with their status (enabled/disabled)
	SELECT 
		job_id, 
		name, 
		enabled 
	FROM msdb.dbo.sysjobs;

-- Extended version with job category included
	SELECT 
		SJ.job_id, 
		SJ.name, 
		SJ.enabled, 
		SC.name AS category
	FROM msdb.dbo.sysjobs SJ
	INNER JOIN msdb.dbo.syscategories SC 
		ON SJ.category_id = SC.category_id;
-----------------------------------------------------------------------------------------------------

-- Disable All SQL Server Agent Jobs
	USE msdb;
	GO

	DECLARE @job_id UNIQUEIDENTIFIER;

	DECLARE job_cursor CURSOR READ_ONLY FOR  
		SELECT job_id
		FROM msdb.dbo.sysjobs
		WHERE enabled = 1;  -- Only currently enabled jobs

	OPEN job_cursor;
	FETCH NEXT FROM job_cursor INTO @job_id;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC msdb.dbo.sp_update_job 
			@job_id = @job_id, 
			@enabled = 0;  -- Disable the job
		FETCH NEXT FROM job_cursor INTO @job_id;
	END

	CLOSE job_cursor;
	DEALLOCATE job_cursor;
-----------------------------------------------------------------------------------------------------

-- Enable All SQL Server Agent Jobs
	USE msdb;
	GO

	DECLARE @job_id UNIQUEIDENTIFIER;

	DECLARE job_cursor CURSOR READ_ONLY FOR  
		SELECT job_id
		FROM msdb.dbo.sysjobs
		WHERE enabled = 0;  -- Only currently disabled jobs

	OPEN job_cursor;
	FETCH NEXT FROM job_cursor INTO @job_id;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC msdb.dbo.sp_update_job 
			@job_id = @job_id, 
			@enabled = 1;  -- Enable the job
		FETCH NEXT FROM job_cursor INTO @job_id;
	END

	CLOSE job_cursor;
	DEALLOCATE job_cursor;
-----------------------------------------------------------------------------------------------------

-- Disable Jobs By Job Category
-- This code will disable any job that is currenlty enabled and the job category is 'Database Maintenance
	USE msdb;
	GO

	DECLARE @job_id UNIQUEIDENTIFIER;

	DECLARE job_cursor CURSOR READ_ONLY FOR  
		SELECT SJ.job_id
		FROM msdb.dbo.sysjobs SJ
		INNER JOIN msdb.dbo.syscategories SC 
			ON SJ.category_id = SC.category_id
		WHERE SJ.enabled = 1
		  AND SC.name = N'Database Maintenance';  -- Targeted job category

	OPEN job_cursor;
	FETCH NEXT FROM job_cursor INTO @job_id;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC msdb.dbo.sp_update_job 
			@job_id = @job_id, 
			@enabled = 0;  -- Disable the job
		FETCH NEXT FROM job_cursor INTO @job_id;
	END

	CLOSE job_cursor;
	DEALLOCATE job_cursor;
-----------------------------------------------------------------------------------------------------
