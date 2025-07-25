Use DBA
---Create Table ---
CREATE TABLE Grocery (
  Grocery_id INT NOT NULL, 
  Grocery_name VARCHAR(30) NOT NULL,
  Grocery_price INT NOT NULL,)
---------------------------------------------
---Insert Values---
INSERT INTO Grocerys VALUES
  (1, 'Beef', 5),
  (2, 'Lettuce', 1),
  (3, 'Tomatoes', 2),
  (4, 'Cheese', 3),
  (5, 'Milk', 1),
  (6, 'Bread', 2);

---------------------------------------------
-- Showing Data---
SELECT * FROM Grocerys
---------------------------------------------
-- Update Data---
UPDATE Grocerys
SET Grocerys_price = 6
WHERE Grocerys_name = 'Beef';
---------------------------------------------
-- Delete Data---
DELETE FROM Grocerys
WHERE Grocerys_name = 'Milk';
---------------------------------------------

