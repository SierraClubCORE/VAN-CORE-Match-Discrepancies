-- Same VAN ID associated with two or more unique people in SF ('Sierra Club (c4)' Committee)

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
WHERE count >1
ORDER BY 14 DESC, 15 ASC;
