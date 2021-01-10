WITH
  current_location(point) AS (
    						VALUES(db2gse.ST_Point( -72.993983,40.824369, 1))
  							)
SELECT
 facility.FACILITYID, facility.FACILITYNAME, facility.ADDRESS1, facility.COUNTY, facility.GEOLOCATION, 
 DECIMAL(db2gse.ST_Distance(geolocation, point ,'STATUTE MILE'), 8, 2) AS distance

	FROM cse532.facility facility 
		inner join cse532.FACILITYCERTIFICATION facility_cert on facility.FACILITYID =facility_cert.FACILITYID  
   		, current_location
	WHERE
   	facility_cert.ATTRIBUTEVALUE = 'Emergency Department'
  	AND
      db2gse.ST_Intersects(geolocation,
      db2gse.ST_Buffer(point, 40.0, 'STATUTE MILE')) = 1
 	SELECTIVITY 0.0001
	
	ORDER BY distance
	FETCH FIRST 1 ROWS ONLY;