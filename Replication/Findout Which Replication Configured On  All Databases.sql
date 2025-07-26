--  Subscription details for replication in SQL Server.
--1
	SELECT * FROM [distribution].dbo.[MSsubscriptions]	
----------------------------------------------------------------------------------------------------------------
--2
-- To check database Offline/Suspect (No Replication)
	SELECT name AS DatabaseName, state_desc
	FROM sys.databases
	WHERE state_desc <> 'ONLINE';
----------------------------------------------------------------------------------------------------------------

-- Query to Show Replication for All Databases
--3
	USE distribution;
	GO

	SELECT 
		pub.publisher_db AS PublisherDB,
		art.article AS ArticleName,
		pub.publication AS PublicationName,
		sub.subscriber_db AS SubscriberDB,
		s.name AS SubscriberServer,
		CASE pub.publication_type
			WHEN 0 THEN 'Transactional'
			WHEN 1 THEN 'Snapshot'
			WHEN 2 THEN 'Merge'
			ELSE 'Unknown'
		END AS ReplicationType,
		CASE sub.subscription_type
			WHEN 0 THEN 'Push'
			WHEN 1 THEN 'Pull'
			WHEN 2 THEN 'Anonymous'
			ELSE 'Unknown'
		END AS SubscriptionType,
		CASE sub.status
			WHEN 1 THEN 'Active'
			WHEN 0 THEN 'Inactive'
			ELSE 'Unknown'
		END AS SubscriptionStatus,
		sd.state_desc AS SubscriberDBState,
		sd.recovery_model_desc,
		sd.log_reuse_wait_desc
	FROM 
		MSpublications pub
	INNER JOIN 
		MSarticles art ON pub.publication_id = art.publication_id
	INNER JOIN 
		MSsubscriptions sub ON art.article_id = sub.article_id AND art.publication_id = sub.publication_id
	INNER JOIN 
		sys.servers s ON sub.subscriber_id = s.server_id
	INNER JOIN 
		sys.databases sd ON sub.subscriber_db = sd.name
	ORDER BY 
		PublisherDB, PublicationName;
----------------------------------------------------------------------------------------------------------------
