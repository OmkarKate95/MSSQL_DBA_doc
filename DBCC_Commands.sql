| ----------------------------- | ----------------------------------------------------------------------------|
|-- Command                     |-- Use                                                                       |
| ----------------------------- | ----------------------------------------------------------------------------|
| DBCC checkalloc		        |-- Checks and reports allocation consistency of database pages.              |			  
| DBCC checkcatalog		        |-- Checks for catalog consistency within the database.			     |			  
| DBCC checkconstraints		|-- Checks integrity of constraints for a table.			             |
| DBCC checkdb			        |-- Checks overall logical and physical integrity of all database objects.    |  
| DBCC checkfilegroup		|-- Checks integrity of specified filegroup.				     |  
| DBCC checkident		        |-- Checks and resets the identity value for a table.			     |
| DBCC checktable		        |-- Checks integrity of all pages and structures of a table or indexed view.  |
| DBCC cleantable		        |-- Removes ghost rows from a specified table.		                     |
| DBCC dbreindex		        |-- Rebuilds one or more indexes for a table (deprecated; use `ALTER INDEX`)  |
| DBCC dropcleanbuffers		|-- Removes all clean buffers from the buffer pool.			     |  
| DBCC flushauthcache		|-- Clears authentication cache entries.					     |  
| DBCC free			|-- Displays memory information (obsolete in newer versions).		     |
| DBCC freeproccache		|-- Clears the procedure cache (removes compiled plans).		             |  
| DBCC freesessioncache		|-- Clears the session--specific cache.					     |  
| DBCC freesystemcache		|-- Clears system--wide caches					             |  
| DBCC help			|-- Lists all available DBCC commands or explains a specific one.	     |
| DBCC indexdefrag		        |-- Defragments clustered and secondary indexes (deprecated).		     |
| DBCC inputbuffer		        |-- Returns the last statement sent from a client to SQL Server.	             |
| DBCC opentran			        |-- Displays information about the oldest open transaction.	             |
| DBCC outputbuffer		        |-- Displays the output buffer of a specified SPID.			     |
| DBCC pintable			        |-- Pins a table in memory (deprecated).					     |
| DBCC proccache		        |-- Displays information about procedure cache usage.			     |
| DBCC show_statistics		|-- Displays statistics information for a table or indexed view.              |  
| DBCC showcontig		        |-- Displays fragmentation information for data/index pages.		     |
| DBCC shrinkdatabase		   |-- Shrinks the size of the data and log files in a database.	             | 
| DBCC shrinkfile		        |-- Shrinks a specified data or log file.				     |
| DBCC sqlperf			        |-- Reports on SQL Server performance statistics like log space.	             |
| DBCC traceoff			        |-- Disables a specified trace flag.	    				     |
| DBCC traceon			        |-- Enables a specified trace flag.					     |
| DBCC tracestatus		        |-- Displays status of trace flags.					     |
| DBCC tuplemover		        |-- Internal use for columnstore indexes; manages tuple movements.	     |
| DBCC unpintable		        |-- Unpins a table from memory (deprecated).				     |
| DBCC updateusage	    	 |-- Reports and corrects page and row count inaccuracies.	             |
| DBCC useroptions		        |-- Returns SET options active for the current session.		             |
| ----------------------------- | ----------------------------------------------------------------------------|











