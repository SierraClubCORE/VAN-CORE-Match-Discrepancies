-- VAN records that have an SFID listed, SFID corresponds to no VANID in SF

CREATE TEMPORARY TABLE step1 AS
SELECT a.statecode, a.vanid, b.salesforceid, a.firstname||' '||a.lastname AS van_fullname, a.committeeid, a.createdby
FROM sc_van_staging.tsm_sc_contacts_myc a
LEFT JOIN sc_van_staging.tsm_sc_contactsexternalids b ON
	a.statecode = b.statecode
	AND a.vanid = b.vanid
	AND a.committeeid = b.committeeid;

SELECT a.statecode, a.vanid, a.van_fullname, b.id AS sf_id, b.van_state__c AS sf_van_state__c, b.van_id_club__c as sf_van_id_club__c, b.mailingstate as sf_mailingstate
FROM step1 a
JOIN sc_analytics.salescloud_contact_w_source b
    ON a.salesforceid = b.id
WHERE b.van_id_club__c IS NULL
    AND a.createdby = 1498035
 	AND a.committeeid = 56610
