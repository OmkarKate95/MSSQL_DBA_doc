-- Database Details 
	SELECT 
		db.database_id AS [Database ID],
		db.name AS [Database Name],
		CONVERT(DECIMAL(10,2), SUM(CAST(mf.size AS BIGINT)) * 8 / 1024) AS [Size (MB)],
		db.recovery_model_desc AS [Recovery Model],
		db.state_desc AS [State],
		db.owner_sid,
		suser_sname(db.owner_sid) AS [Owner],
		db.create_date AS [Creation Date]
	FROM sys.databases AS db
	JOIN sys.master_files AS mf
		ON db.database_id = mf.database_id
	GROUP BY 
		db.database_id, 
		db.name, 
		db.recovery_model_desc, 
		db.state_desc, 
		db.owner_sid, 
		db.create_date
	ORDER BY db.database_id;
