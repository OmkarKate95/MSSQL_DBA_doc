-- We can enabled backup compression two ways 1. Graphical Through 2. Script Through
--1. Object Explorer --> Right click instanance --> properties --> Database Setting --> check compression backup

-- you can check backup compression is enabled or not through script
	sp_configure

	EXEC sys.sp_configure N'backup compression default', N'0'
	GO
	RECONFIGURE
	GO