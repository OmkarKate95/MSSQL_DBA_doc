-- DAC Connection [Dedicated admin connection]
	
	sp_configure 'remote admin connections', 1  -- 1 = TRUE, 0 = FALSE
	GO  
	RECONFIGURE  

-- GUI Method:
-- In SSMS > Right-click Server > Properties > Go to Connections > Check "Allow remote connections for DAC"
----------------------------------------------------------------------------------------------------------------

-- How to enable backup compression

	sp_configure
	sp_configure 'backup compression default', 1  -- 1 = TRUE, 0 = FALSE
	GO  
	RECONFIGURE  

-- GUI Method:
-- Right-click Server > Properties > Database Settings > Under Backup, check "Compress backup"
---------------------------------------------------------------------------------------------------------------

-- Set Min, Max Memory
	
	sp_configure 'max server memory (MB)', 8000  -- In MB 1024mb = 1gb
	GO  
	RECONFIGURE

-- GUI Method:
-- SSMS > Right-click Server > Properties > Memory > Adjust Min/Max server memory
---------------------------------------------------------------------------------------------------------------

