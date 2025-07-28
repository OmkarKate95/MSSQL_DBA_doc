USE PerfDB;
GO

BEGIN TRAN;
UPDATE emp 
SET name = 'ajay'
WHERE id = 100;

ROLLBACK;
