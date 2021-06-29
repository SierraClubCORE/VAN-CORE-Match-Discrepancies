-- VAN records that do not have an SFID listed

SELECT a.statecode, a.vanid, b.salesforceid, a.firstname||' '||a.lastname AS van_fullname
FROM sc_van_staging.tsm_sc_contacts_myc a
LEFT JOIN sc_van_staging.tsm_sc_contactsexternalids b ON
	a.statecode = b.statecode
	AND a.vanid = b.vanid
	AND a.committeeid = b.committeeid
WHERE b.salesforceid IS NULL
	AND a.createdby = 1498035
	AND a.committeeid = 56610;
