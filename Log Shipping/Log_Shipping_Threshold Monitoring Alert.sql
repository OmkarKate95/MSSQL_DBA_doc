
-- Enables alert threshold monitoring on the configured log shipping databases.

-- On Primary Server
	EXEC master.dbo.sp_change_log_shipping_secondary_database 
		@secondary_database = N'database_name', 
		@threshold_alert_enabled = 1;

-- On Secondary Server
	EXEC master.dbo.sp_change_log_shipping_primary_database 
		@database = N'database_name', 
		@threshold_alert_enabled = 1;
