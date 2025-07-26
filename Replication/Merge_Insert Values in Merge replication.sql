-- Select the top 1000 rows from the THINKPAD table

SELECT TOP (1000) [LAPTOPID], [MODEL_NAME], [rowguid]
FROM [DELL_MERGE].[dbo].[THINKPAD]
-------------------------------------------------------------------------

-- To Inset Values on Merge Repclicaiton

INSERT INTO [DELL_MERGE].[dbo].[THINKPAD] ([LAPTOPID], [MODEL_NAME]) 
VALUES (6, 100)

--------------------------------------------------------------------------