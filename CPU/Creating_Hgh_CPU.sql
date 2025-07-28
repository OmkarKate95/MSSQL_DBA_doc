-- To Create High CPU
	USE PerfDB 
	SELECT * FROM emp
	ORDER BY name DESC ,salary DESC
	GO 