-- Active Job Notification 
	USE msdb;

	-- Check if there are any ENABLED SQL Agent Jobs
	IF EXISTS (
		SELECT * 
		FROM sysjobs
		WHERE enabled <> 0  -- Job is enabled (1 = enabled, 0 = disabled)
	)
	BEGIN
		-- Send email notification
		EXEC msdb.dbo.sp_send_dbmail  
			@profile_name = 'Airportwala',					  -- Your DB Mail Profile
			@recipients = 'omkarkate@gmail.com',		      -- Email recipient
			@body = '<b>CHECK DATABASE STATUS</b>',           -- Email body content (HTML)
			@subject = 'Job Is Enable',           -- Email subject
			@body_format = 'HTML';                            -- Send as HTML format
	END
