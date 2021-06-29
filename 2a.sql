-- Duplicate Records existing in SF where the name, address, and zip5 are the same

CREATE TEMPORARY TABLE step1 AS
SELECT firstname, lastname, mailingstreet, mailingpostalcode, count(*)
FROM sc_analytics.salescloud_contact_w_source
WHERE van_state__c IS NOT NULL
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

SELECT b.id, b.firstname, b.lastname, b.mailingstreet, b.mailingcity, UPPER(b.mailingstate) AS mailingstate, b.mailingpostalcode, b.phone, b.email, b.van_id_club__c, b.van_id_foundation__c, b.van_id_voter_file_club__c, b.van_state__c, a.count, a.firstname + a.lastname + a.mailingstreet + a.mailingpostalcode AS key
FROM step1 a
JOIN sc_analytics.salescloud_contact_w_source b
ON a.firstname + a.lastname + a.mailingstreet + a.mailingpostalcode = b.firstname + b.lastname + b.mailingstreet + b.mailingpostalcode
WHERE count > 1
ORDER BY 14 DESC, 15 ASC;
