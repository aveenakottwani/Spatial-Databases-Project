insert into cse532.facility (
FacilityID ,
FacilityName ,
Description ,
Address1 ,
Address2 ,
City ,
State ,
ZipCode ,
CountyCode ,
County ,Geolocation) 

select 
FacilityID ,
FacilityName ,
Description ,
Address1 ,
Address2 ,
City ,
State ,
ZipCode ,
CountyCode ,
County ,
DB2GSE.ST_POINT(longitude,latitude ,1)
from cse532.facilityoriginal;
