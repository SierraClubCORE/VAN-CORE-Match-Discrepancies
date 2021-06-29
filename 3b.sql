-- A variant of the cases in 3a. Characteristics are:
-- * Same myC VANID associated with multiple SF records
-- * The SF records do not appear to represent the same person based on visual inspection
-- * All corresponding SF records have voter file VAN ID, which is different for each SF record
-- * When looking up the myC VANID in VAN, the listed SFID’s SF record has a different VoterFileVANID associated with it then what’s listed in myC

CREATE TEMPORARY TABLE step1 AS
SELECT van_id_club__c, van_state__c, count(*)
FROM sc_analytics.salescloud_contact_w_source
WHERE van_id_club__c IS NOT NULL
GROUP BY 1,2
ORDER BY 3 DESC;

SELECT b.id, b.firstname, b.lastname, b.mailingstreet, b.mailingcity, UPPER(b.mailingstate) AS mailingstate, b.mailingpostalcode, b.phone, b.email, b.van_id_club__c, b.van_id_foundation__c, b.van_id_voter_file_club__c, b.van_state__c, a.count, a.van_state__c||a.van_id_club__c 
FROM step1 a
JOIN sc_analytics.salescloud_contact_w_source b
ON a.van_id_club__c = b.van_id_club__c
AND a.van_state__c = b.van_state__c
WHERE van_id_voter_file_club__c IS NOT NULL
AND count > 1
ORDER BY 14 DESC, 15 ASC;
