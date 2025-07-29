	Use PerfDB

SELECT 
    t.NAME AS TableName,
    s.Name AS SchemaName,
    p.rows,

	-- Total space
    SUM(a.total_pages) * 8 AS TotalSpaceKB, 
    CAST(ROUND(((SUM(a.total_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 2)) AS TotalSpaceMB,

	-- Used space
    SUM(a.used_pages) * 8 AS UsedSpaceKB, 
    CAST(ROUND(((SUM(a.used_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 2)) AS UsedSpaceMB, 

	-- Unused space
    (SUM(a.total_pages) - SUM(a.used_pages)) * 8 AS UnusedSpaceKB,
    CAST(ROUND(((SUM(a.total_pages) - SUM(a.used_pages)) * 8) / 1024.00, 2) AS NUMERIC(36, 2)) AS UnusedSpaceMB,
	-- Percentage of unused space
    CAST(ROUND(((SUM(a.total_pages) - SUM(a.used_pages)) * 1.0 / NULLIF(SUM(a.total_pages), 0)) * 100, 2) AS NUMERIC(5,2)) AS UnusedPercent

FROM 
	sys.tables t
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    INNER JOIN sys.indexes i ON t.object_id = i.object_id
    INNER JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
    INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id

WHERE 
    t.is_ms_shipped = 0  -- user tables only
    AND t.name NOT LIKE 'dt%'  -- exclude diagrams or temp objects
    AND i.object_id > 255

GROUP BY 
    t.Name, s.Name, p.Rows

ORDER BY 
    TotalSpaceMB DESC, t.Name
