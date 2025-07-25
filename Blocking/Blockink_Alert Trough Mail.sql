-- Note:

       This is alert for blocking more than 15 Min

--Make Correction

--- 1. Select @Profile = 'Your ProfileName'

--- 2.  Select @RECIPIENTS = 'RECIPIENTS@Test.com;'

Declare @Profile nvarchar(100)
Select @Profile = 'Airportwala'

Declare @RECIPIENTS varchar(500)
Select @RECIPIENTS = 'omkar.k@gmail.com'

Declare  @BlockingMS   [int]
Select @BlockingMS   = 90000

 

--Select @BlockingMS   = 900000

DECLARE @count int
DECLARE @tableHTML  NVARCHAR(MAX) ;

CREATE TABLE #Temp_Lock_monitor

            (

                    LoginName varchar(50),

                    dbname varchar(50),

                    Spid int,

                    Blocked int,

                    hostname varchar(100),

                    lastactivitytime datetime,

                    lastwaittype varchar(50),

                    waitname varchar(50),

                    waittime int,

                    sqltext varchar(4000)

             );


WITH BLOCKERS (SPID, BLOCKED, LEVEL, BATCH,waittype,lastwaittype,hostname,dbname)

AS
(   
		SELECT   SPID,   BLOCKED,

		CAST (REPLICATE ('0', 4-LEN (CAST (SPID AS VARCHAR))) + CAST (SPID AS VARCHAR) AS VARCHAR (1000)) AS LEVEL,
		REPLACE (REPLACE (T.TEXT, CHAR(10), ' '), CHAR (13), ' ' ) AS BATCH,

		R.waittype,

		R.lastwaittype,

		r.hostname,

		db_name(r.dbid) [DBName]

		FROM sys.sysprocesses R with (nolock)

		CROSS APPLY SYS.DM_EXEC_SQL_TEXT(R.SQL_HANDLE) T

		WHERE (BLOCKED = 0 OR BLOCKED = SPID)

   AND EXISTS    
   (SELECT SPID,BLOCKED,CAST (REPLICATE ('0', 4-LEN (CAST (SPID AS VARCHAR))) + CAST (SPID AS VARCHAR) AS VARCHAR (1000)) AS LEVEL,

   BLOCKED, REPLACE (REPLACE (T.TEXT, CHAR(10), ' '), CHAR (13), ' ' ) AS BATCH,R.waittype,R.lastwaittype FROM sys.sysprocesses R2 with (nolock)

   CROSS APPLY SYS.DM_EXEC_SQL_TEXT(R.SQL_HANDLE) T

WHERE R2.BLOCKED = R.SPID AND R2.BLOCKED <> R2.SPID  and r2.waittime > @BlockingMs)

UNION ALL

SELECT

		R.SPID,

		R.BLOCKED,

		CAST (BLOCKERS.LEVEL + RIGHT (CAST ((1000 + R.SPID) AS VARCHAR (100)), 4) AS VARCHAR (1000)) AS LEVEL,

		REPLACE (REPLACE (T.TEXT, CHAR(10), ' '), CHAR (13), ' ' ) AS BATCH,

		R.waittype,

		R.lastwaittype,

		r.hostname,

		db_name(r.dbid) [DBName]

FROM sys.sysprocesses AS R with (nolock)

		CROSS APPLY SYS.DM_EXEC_SQL_TEXT(R.SQL_HANDLE) T

		INNER JOIN BLOCKERS ON R.BLOCKED = BLOCKERS.SPID WHERE R.BLOCKED > 0 AND R.BLOCKED <> R.SPID and r.waittime > @BlockingMS

)

Insert Into #Temp_Lock_monitor

Select  
CASE blocked

      WHEN 0 THEN s.login_name

      ELSE REPLICATE ('---', LEN (b.LEVEL)/4 - 1) + s.login_name

END 
		[Login Name],

        b.dbname, b.spid, b.blocked [Blocked By], b.hostname,
		s.last_request_start_time [Last Activity Time],

		lastwaittype [Last Wait Type] ,

CASE lastwaittype

                          WHEN 'LCK_M_SCH_S' THEN 'Schema stability'

                          WHEN 'LCK_M_SCH_M' THEN 'Schema modification'

                          WHEN 'LCK_M_S' THEN 'Share'

                          WHEN 'LCK_M_U' THEN 'Update'

                          WHEN 'LCK_M_X' THEN 'Exclusive'

                          WHEN 'LCK_M_IS' THEN 'Intent-Share'

                          WHEN 'LCK_M_IU' THEN 'Intent-Update'

                          WHEN 'LCK_M_IX' THEN 'Intent-Exclusive'

                          WHEN 'LCK_M_SIU' THEN 'Shared intent to update'

                          WHEN 'LCK_M_SIX' THEN 'Share-Intent-Exclusive'

                          WHEN 'LCK_M_UIX' THEN 'Update-Intent-Exclusive'

                          WHEN 'LCK_M_BU' THEN 'Bulk Update'

                          WHEN 'LCK_M_RS_S' THEN 'Range-share-share'

                          WHEN 'LCK_M_RS_U' THEN 'Range-share-Update'

                          WHEN 'LCK_M_RI_NL' THEN 'Range-Insert-NULL'

                          WHEN 'LCK_M_RI_S' THEN 'Range-Insert-Shared'

                          WHEN 'LCK_M_RI_U' THEN 'Range-Insert-Update'

                          WHEN 'LCK_M_RI_X' THEN 'Range-Insert-Exclusive'

                          WHEN 'LCK_M_RX_S' THEN 'Range-exclusive-Shared'

                          WHEN 'LCK_M_RX_U' THEN 'Range-exclusive-update'

                          WHEN 'LCK_M_RX_X' THEN 'Range-exclusive-exclusive'

                          ELSE lastwaittype

END,

                          
CASE B.BLOCKED 
							WHEN 0 THEN 0 ELSE R.WAIT_TIME/1000 
END [Wait Time], batch [SQLTEXT]

FROM BLOCKERS b with (nolock)

		inner join sys.dm_exec_sessions s on b.spid = s.session_id
        left outer join sys.dm_exec_requests r on b.spid = r.session_id

ORDER BY LEVEL ASC

 

SET @count = (@@ROWCOUNT)

If @count > 0

BEGIN

 

  SET @tableHTML =

       N'<STYLE> body {font:10pt Arial,Helvetica,sans-serif; color:black; background:White;} '+

				N' table,tr,td {font:10pt Arial,Helvetica,sans-serif; color:Black; background:#f7f7e7;'+

				N'              padding:0px 0px 0px 0px; margin:0px 0px 0px 0px;}'+

				N' th {font:bold 10pt Arial,Helvetica,sans-serif; color:#336699; background:#cccc99;'+

				N'              padding:0px 0px 0px 0px;}</STYLE>' +

				N'<H1>Blocking for longer than '+ convert(varchar, @BlockingMS / 1000) +' seconds </H1>'+
	
				N'<TABLE BORDER=10>' +

				N'<tr>' +

				N'<th>User Name</th>' +

				N'<th>DB Name</th>' +

				N'<th>SPID</th>' +

				N'<th>Blocked By</th>' +

				N'<th>Hostname</th>' +

				N'<th>Last Active Time</th>' +

				N'<th>Last Wait Type</th>' +

				N'<th>Last Wait Name</th>' +

				N'<th>Wait Time seconds</th>' +

				N'<th>SQL</th>' +

				N'</tr>' +

    CAST ( (

    SELECT td = LoginName, '',

           td = DBName,'',

           td = spid,'',

           td = Blocked,'',

           td = hostname,'',

           td = lastactivitytime,'',

           td = lastwaittype,'',

           td = Waitname,'',

           td = WAITTIME,'',

           td = SQLTExt,''

FROM    #Temp_Lock_monitor
   
FOR XML PATH('tr'), TYPE

    ) AS NVARCHAR(MAX) ) +

    N'</table>' ;  
 

Declare @SUBJECT varchar(60)

SET @SUBJECT=@@SERVERNAME +' Blocking '

 

EXEC msdb.dbo.sp_send_dbmail

                           @profile_name=@Profile,

                           @recipients=@RECIPIENTS,

                           @subject=@SUBJECT,

                           @body = @tableHTML,

                           @body_format = 'HTML' ;

 

PRINT @TABLEHTML

DROP TABLE #Temp_Lock_monitor

END