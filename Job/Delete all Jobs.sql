-- To Delete all Jobs

	SET NOCOUNT ON;

	DECLARE @Job TABLE (JobName SYSNAME);
	DECLARE @JobName SYSNAME = '';
	DECLARE @Sql VARCHAR(MAX);

	-- Step 1: Insert job names NOT related to Maintenance Plans
	INSERT INTO @Job (JobName)
	SELECT j.name
	FROM msdb.dbo.sysjobs AS j
	LEFT JOIN msdb.dbo.sysmaintplan_subplans AS p ON j.job_id = p.job_id
	WHERE p.subplan_id IS NULL
	ORDER BY j.name ASC;

	-- Step 2: Loop through the jobs and generate delete statements
	WHILE 1 = 1
	BEGIN
		SELECT TOP 1 @JobName = JobName
		FROM @Job
		WHERE JobName > ISNULL(@JobName, '')
		ORDER BY JobName;

		IF @JobName IS NULL
			BREAK;

		SET @Sql = '
	EXEC msdb.dbo.sp_delete_job @job_name = ''' + @JobName + ''';';
    
		PRINT @Sql;
	END
