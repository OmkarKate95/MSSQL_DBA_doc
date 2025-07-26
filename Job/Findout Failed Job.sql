--Find Failed SQL Agent Job Steps in Last 7 Days

-- Variable Declarations
	DECLARE @PreviousDate DATETIME;
	DECLARE @Year VARCHAR(4);
	DECLARE @Month VARCHAR(2);
	DECLARE @MonthPre VARCHAR(2);
	DECLARE @Day VARCHAR(2);
	DECLARE @DayPre VARCHAR(2);
	DECLARE @FinalDate INT;


	SET @PreviousDate = DATEADD(DAY, -7, GETDATE());           -- Get date 7 days ago
	SET @Year = DATEPART(YEAR, @PreviousDate);                 -- Extract year
	SELECT @MonthPre = CONVERT(VARCHAR(2), DATEPART(MONTH, @PreviousDate)); 
	SELECT @Month = RIGHT(CONVERT(VARCHAR, @MonthPre + 1000000000), 2);     -- Always 2 digits

	SELECT @DayPre = CONVERT(VARCHAR(2), DATEPART(DAY, @PreviousDate));
	SELECT @Day = RIGHT(CONVERT(VARCHAR, @DayPre + 1000000000), 2);         -- Always 2 digits

	SET @FinalDate = CAST(@Year + @Month + @Day AS INT);


-- List Failed Job Steps 
	SELECT 
		j.name AS JobName,
		s.step_name AS StepName,
		h.step_id,
		h.step_name,
		h.run_date,
		h.run_time,
		h.sql_severity,
		h.message,
		h.server
	FROM msdb.dbo.sysjobhistory h
	INNER JOIN msdb.dbo.sysjobs j
		ON h.job_id = j.job_id
	INNER JOIN msdb.dbo.sysjobsteps s
		ON j.job_id = s.job_id
		AND h.step_id = s.step_id
	WHERE h.run_status = 0                   -- 0 = Failed step
	  AND h.run_date > @FinalDate            -- Filter for last 7 days
	ORDER BY h.instance_id DESC;             -- Most recent first
