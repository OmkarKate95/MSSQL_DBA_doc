--Clean pages and Dirty pages count

SELECT (
			CASE
				WHEN ( [database_id] = 32767 ) THEN 'Resource Database'
				ELSE Db_name (database_id)
			END 
		)  AS 'Database Name',

       Sum
	   (
			CASE
				WHEN ( [is_modified] = 1 ) THEN 0
				ELSE 1
			END
		) AS 'Clean Page Count',

        Sum
		(	
			CASE
				WHEN ( [is_modified] = 1 ) THEN 1
				ELSE 0
           END
		) AS 'Dirty Page Count'

FROM   sys.dm_os_buffer_descriptors

GROUP  BY database_id

ORDER  BY DB_NAME(database_id);