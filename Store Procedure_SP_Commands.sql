| ------------------------- | ----------------------------------------------------------------------------|
|-- Command                 |-- Use                                                                       |
| ------------------------- | ----------------------------------------------------------------------------|
| sp_help		    |-- Displays details about a database object (table, view, procedure, etc.).  |
| sp_helpfile		    |-- Shows info about data/log files of the current database.                  |
| sp_helpdb		    |-- Lists all databases with basic info (size, owner, status, etc.).          |
| sp_helplogins		    |-- Lists all logins and associated server-level info.                        |
| sp_helptext		    |-- Displays the text (definition) of a stored procedure, function, or view.  |
| sp_helpindex		    |-- Displays information about indexes on a table.                            |
| sp_who		    |-- Lists current users, sessions, and processes.                             |
| sp_who2		    |-- Extended version of `sp_who`, with more session info (CPU, I/O, etc.).    |
| sp_lock		    |-- Returns info about locks held by active SQL Server processes.             |
| sp_monitor		    |-- Returns statistics about SQL Server resource usage.                       |
| sp_databases		    |-- Lists all databases on the instance.                                      |
| sp_tables		    |-- Lists all tables accessible in the current database.                      |
| sp_columns		    |-- Lists all columns for a specified table or view.                          |
| sp_renamedb		    |-- Renames a database.                                                       |
| sp_rename		    |-- Renames a database object (column, index, etc.).                          |
| sp_addlogin		    |-- Adds a new SQL Server login (deprecated).                                 |
| sp_grantdbaccess	    |-- Grants a user access to the current database.                             |
| sp_revokedbaccess	    |-- Revokes user access from the current database.                            |
| sp_change_users_login	    |-- Maps orphaned users to logins (used in SQL Server 2000 2012).             |
| sp_changedbowner	    |-- Changes the database owner (deprecated; use ALTER AUTHORIZATION).         |
| sp_configure		    |-- Configures server-level options (e.g., max memory, show advanced options).|
| sp_msforeachdb	    |-- Executes a command for each database.                                     |
| sp_msforeachtable	    |-- Executes a command for each table in a database.                          |
| sp_executesql		    |-- Executes a dynamically built SQL statement with parameters.               |
| sp_recompile		    |-- Marks a stored procedure for recompilation.                               |
| sp_depends		    |-- Shows dependencies of an object (deprecated).                             |
| sp_fkeys		    |-- Lists foreign keys referencing a table.                                   |
| sp_pkeys		    |-- Lists primary key columns of a table.                                     |
| sp_ms_marksystemobject    |-- Marks a procedure as a system object (internal use).                      |
| sp_adduser		    |-- Adds a user to the database (deprecated).				    |
| sp_addrole		    |-- Adds a new database role.						    |
| sp_addrolemember	    |-- Adds a user to a role.						|
| sp_droprolemember	    |-- Removes a user from a role.						    |
| sp_droprole		    |-- Deletes a database role.						    |
| ------------------------- | ----------------------------------------------------------------------------|
