-- Create Database
	Create database Pk
--------------------------------------------------------------
-- Backup Full

	Backup database Pk
	to disk = 'D:\SSMS Training\Backup\Pk_full.bak'
--------------------------------------------------------------
-- Differential Backup

	Backup database Pk
	to disk = 'D:\SSMS Training\Backup\Pk_diff.bak'
	with differential
--------------------------------------------------------------
-- Tlog Backup

	Backup log Pk
	to disk = 'D:\SSMS Training\Backup\Pk_tlog.trn'
--------------------------------------------------------------
-- Tail log backup

	Backup log Pk
	to disk = 'D:\SSMS Training\Backup\Pk_taillog.trn'
	with no_truncate, norecovery
--------------------------------------------------------------

Restore Database Pk with recovery

-- Restoring the DB

	Restore database Pk
	from disk = 'D:\SSMS Training\Backup\Pk_full.bak'
	with replace, norecovery
--------------------------------------------------------------
--Diff Restore

	Restore database Pk
	From disk = 'D:\SSMS Training\Backup\Pk_diff.bak'
	with norecovery
--------------------------------------------------------------
-- Tlog Restore

	Restore log Pk
	From disk = 'D:\SSMS Training\Backup\Pk_tlog.trn'
	with recovery
--------------------------------------------------------------