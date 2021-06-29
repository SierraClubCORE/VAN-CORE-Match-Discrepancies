-- Two or more SF records that appear to be duplicates; associated with different VAN IDs in different states

CREATE TEMPORARY TABLE vanstep1 AS
SELECT a.statecode, a.vanid, b.salesforceid, a.firstname, a.lastname, a.committeeid, a.createdby, a.datemodified, a.datesuppressed
FROM sc_van_staging.tsm_sc_contacts_myc a
JOIN sc_van_staging.tsm_sc_contactsexternalids b ON
	a.statecode = b.statecode
	AND a.vanid = b.vanid
	AND a.committeeid = b.committeeid;

CREATE TEMPORARY TABLE vanstep2 AS
SELECT a.statecode, a.vanid, a.salesforceid, a.firstname, a.lastname, cc.committeename, u.canvassername AS createdbyname, a.datemodified, a.datesuppressed
FROM vanstep1 a
LEFT JOIN sc_van_staging.tsm_sc_users u ON
        a.createdby = u.userid
LEFT JOIN sc_van_staging.tsm_sc_committees cc ON
        a.committeeid = cc.committeeid
WHERE createdbyname IN ('API (c3), SalesforceSierraClub', 'API (c4), SalesforceSierraClub');

CREATE TEMPORARY TABLE sfstep1 AS
SELECT firstname, lastname, mailingstreet, mailingpostalcode, count(*)
FROM sc_analytics.salescloud_contact_w_source
WHERE van_state__c IS NOT NULL
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

CREATE TEMPORARY TABLE sfstep2 AS
SELECT b.id, b.firstname, b.lastname, b.mailingstreet, b.mailingcity, UPPER(b.mailingstate) AS mailingstate, b.mailingpostalcode, b.phone, b.email, b.van_id_club__c, b.van_id_foundation__c, b.van_id_voter_file_club__c, b.van_state__c, b.createddate, a.count, a.firstname + a.lastname + a.mailingstreet + a.mailingpostalcode AS key
FROM sfstep1 a
JOIN sc_analytics.salescloud_contact_w_source b
ON a.firstname + a.lastname + a.mailingstreet + a.mailingpostalcode = b.firstname + b.lastname + b.mailingstreet + b.mailingpostalcode
WHERE count > 1
ORDER BY 15 DESC, 16 ASC;

SELECT a.id, a.firstname, a.lastname, a.mailingstreet, a.mailingcity, a.mailingstate, a.mailingpostalcode, a.phone, a.email, a.van_id_club__c, a.van_id_foundation__c, a.van_id_voter_file_club__c, a.van_state__c, a.createddate, a.count, a.key, b.statecode, b.vanid, b.committeename, b.createdbyname, b.datemodified, CASE WHEN (createdbyname = 'API (c3), SalesforceSierraClub' AND b.vanid <> a.van_id_foundation__c) OR (createdbyname = 'API (c4), SalesforceSierraClub' AND b.vanid <> a.van_id_club__c) THEN 1 ELSE 0 END AS vanid_mismatch
FROM sfstep2 a
LEFT JOIN vanstep2 b 
	ON a.id = b.salesforceid
ORDER BY 15 DESC, 16 ASC;
