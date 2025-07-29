IF EXISTS (
    SELECT * 
    FROM sys.syslogins 
    WHERE sysadmin = 1
)
BEGIN
    EXEC msdb.dbo.sp_send_dbmail  
        @profile_name = 'Airportwala',				-- DB Mail Profile Name
        @recipients = 'omkarkate@gmail.com',		-- Email Id
        @body = '<b>CHECK DATABASE STATUS</b>', 
        @subject = 'Automated Success Message', 
        @body_format = 'HTML';
END
