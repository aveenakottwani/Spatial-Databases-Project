WITH EveryZIP AS (

	SELECT SUBSTR(u.GEOID10,1,5) AS zip, u.SHAPE
	FROM CSE532.USZIP u , CSE532.FACILITY f 
	WHERE GEOID10 = SUBSTR(f.ZIPCODE,1,5) 
	)
, ZIP_ONLY_ER AS (
---ER zip codes
	SELECT SUBSTR(f.ZIPCODE,1,5) AS zipcodes, u2.SHAPE
	FROM CSE532.FACILITY f
	 join  CSE532.FACILITYCERTIFICATION fc on f.FACILITYID = fc.FACILITYID 
	 join CSE532.USZIP u2 on f.ZIPCODE = u2.GEOID10
	WHERE 
	 fc.ATTRIBUTEVALUE LIKE 'Emergency Department'
	 
) 
, neighborER AS (
--Neighbor of ER zipcodes
	SELECT DISTINCT e2.zip 
	FROM EveryZIP e1, EveryZIP e2
	WHERE db2gse.ST_Touches(e1.shape, e2.shape) = 1
	and e1.zip IN (SELECT zipcodes FROM ZIP_ONLY_ER)
) 

, requiredZIPs AS (
--ER + Neighbour of ER zipcodes =requiredZIPs
	SELECT DISTINCT ISNULL(t.zipcodes,t1.zip) as zip
		FROM ZIP_ONLY_ER t FULL OUTER JOIN neighborER t1 ON t.zipcodes = t1.zip
)


--All zipcodes except ER + Neighbour of ER zipcodes
SELECT DISTINCT ZIP FROM EveryZIP
 WHERE zip NOT IN (SELECT * FROM requiredZIPs);
