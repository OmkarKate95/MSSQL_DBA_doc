-- Change Authantication Mode
	USE [master]
	GO

	EXEC xp_instance_regwrite 
			N'HKEY_LOCAL_MACHINE',
			N'Software\Microsoft\MSSQLServer\MSSQLServer',
			N'LoginMode', 
			REG_DWORD, 
			2   -- 1 = Windows Authentication only, 2 = Mixed Mode (SQL + Windows)
	GO

--------------------------------------------------------------------------------------------

-- Safer Alternative via SSMS--

		-- Right-click the server name in SSMS ? Properties.

		-- Click on Security.

		-- Choose SQL Server and Windows Authentication mode.

		-- Restart SQL Server service. 
--------------------------------------------------------------------------------------------

-- Via SQL Server Configuration Manager

		-- Open SQL Server Configuration Manager.

		-- In the left pane, select SQL Server Services.

		-- In the right pane, right-click on your instance (e.g., SQL Server (MSSQLSERVER)) > Restart.
--------------------------------------------------------------------------------------------
