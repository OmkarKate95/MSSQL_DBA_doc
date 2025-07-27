-- 1. Create EMP database and emp table
		
		CREATE DATABASE EMP;

		USE EMP;

		CREATE TABLE emp ( id INT NOT NULL,	name NVARCHAR(50) NOT NULL,	deptid INT NOT NULL	);

		INSERT INTO emp (id, name, deptid)
		VALUES
			(1, 'ABS', 100),
			(2, 'B', 100),
			(3, 'C', 100),
			(4, 'D', 200);

		SELECT * FROM emp;

-- 2. Create DEPT database and dept table
		
		CREATE DATABASE dept;

		USE dept;

		CREATE TABLE dept ( depid INT, deptname NVARCHAR(50));

		INSERT INTO dept
		VALUES
			(100, 'HR'),
			(100, 'DBA'),
			(100, 'ML');

		SELECT * FROM dept;

-- 3. Update and Transaction Testing
		USE EMP;
		GO

		UPDATE emp 
		SET deptid = 101
		WHERE id = 2;

-- Transaction 
		BEGIN TRAN --- Start transaction

		DELETE FROM emp WHERE id = 4;
		GO


		ROLLBACK -- You can rollback to undo delete
		COMMIT	 -- Commit to make delete permanent

SELECT * FROM emp;
