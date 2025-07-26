-- Add on articles to transactional replication publication

-- STEP 1. First, change the allow_anonymous property of the publication to FALSE
		EXEC sp_changepublication
		@publication = 'Publication_Name',
		@property = 'allow_anonymous',
		@value = 'FALSE'
		GO

-- STEP 2. Next, disable Change immediate_sync
		EXEC sp_changepublication
		@publication = 'Publication_Name',
		@property = 'immediate_sync',
		@value = 'FALSE'
		GO

-- STEP 3. Add Article Manually to Publication
-- Replication --> Local Publication --> Select your Publication--> Article --> check on New Article

-- STEP 4. Run Snapshot agent Manually

-- STEP 5. Enable Change immediate_sync
		EXEC sp_changepublication
		@publication = 'Publication_Name',
		@property = 'immediate_sync',
		@value = 'True'
		GO

-- STEP 6. Change the allow_anonymous property of the publication to True
		EXEC sp_changepublication
		@publication = 'Publication_Name',
		@property = 'allow_anonymous',
		@value = 'TRUE'
		GO