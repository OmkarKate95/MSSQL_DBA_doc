-- Findout Number Of Connections on Databases
	SELECT 
		DB_NAME(dbid) as DBName, 
		COUNT(dbid) as NumberOfConnections,
		loginame as LoginName
	FROM
		sys.sysprocesses
	WHERE 
		dbid > 4
	GROUP BY 
		dbid, loginame;
