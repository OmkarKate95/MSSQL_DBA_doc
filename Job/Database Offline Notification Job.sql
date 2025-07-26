-- Database offline notification job
-- View linked server configurations
SELECT * 
FROM sys.sysservers;

-- Check if any database is NOT in ONLINE state
IF EXISTS (
    SELECT * 
    FROM sys.databases
    WHERE state_desc <> 'ONLINE'
)
BEGIN
    -- Send an email alert using Database Mail
    EXEC msdb.dbo.sp_send_dbmail  
        @profile_name = 'Airportwala',          -- Your configured DB Mail profile
        @recipients = 'omkarkate@gmail.com',          -- Recipient email address
        @body = '<b>CHECK DATABASE STATUS</b>',          -- Message body (in HTML)
        @subject = 'Database is OFFLINE',          -- Subject of the email
        @body_format = 'HTML';                           -- Format set to HTML
END
