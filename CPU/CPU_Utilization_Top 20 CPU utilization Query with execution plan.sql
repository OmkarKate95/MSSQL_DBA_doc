--Top 20 CPU utilization Query with execution plan

SELECT TOP (20)

    st.text AS Query,
    qs.execution_count,
    qs.total_worker_time AS Total_CPU,
    total_CPU_inSeconds = --Converted from microseconds
    qs.total_worker_time/1000000,
    average_CPU_inSeconds = --Converted from microseconds
    (qs.total_worker_time/1000000) / qs.execution_count,
    qs.total_elapsed_time,
    total_elapsed_time_inSeconds = --Converted from microseconds
    qs.total_elapsed_time/1000000,
    qp.query_plan

FROM sys.dm_exec_query_stats AS qs

	CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
	CROSS apply sys.dm_exec_query_plan (qs.plan_handle) AS qp

ORDER BY qs.total_worker_time DESC OPTION (RECOMPILE);