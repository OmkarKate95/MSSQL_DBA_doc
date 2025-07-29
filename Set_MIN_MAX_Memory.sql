
-- We can set min - max memory two ways 
-- 1. Object Explorer --> Right click instanance --> properties --> memory --> set min-max memory

-- 2. Script Through
-- Check how much memory set through sp_configure
	sp_configure


-- Set Maximum memory
	exec sys.sp_configure 'max server memory (MB)','MEMORY SIZE in MB' 
	go
	reconfigure
	go


-- Set minimum memory
	exec sys.sp_configure 'min server memory (MB)','MEMORY SIZE in MB' 
	go
	reconfigure
	go

