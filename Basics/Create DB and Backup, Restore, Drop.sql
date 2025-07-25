--Create database--
Create database Nissi

--Get backup of database Full, Diffrential and Log --

--Full Backup--
Backup database Nissi to disk='D:\SSMS\Backup\Nissi_full.bak'

--Diffrential Backup--
Backup database Nissi to disk='D:\SSMS\Backup\Nissi_diff.bak' with differential

--Log Backup--
Backup log Nissi to disk='D:\SSMS\Backup\Nissi_log.trn'


Drop database Nissi

--Restore Database--
Restore database Nissi from disk= 'D:\SSMS\Backup\Nissi_full.bak' with replace


--Use database--
Use Nissi

--If you want to delete Use Database, so first Use Master and then delete/drop database
Use master
--Drop Database--
Drop database Nissi



