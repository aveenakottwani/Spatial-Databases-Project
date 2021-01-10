drop index cse532.facilityGeo_index;
drop index cse532.zip_shape_index;
drop index cse532.zip_geoId_index;
drop index cse532.facilitycerf_attriValue_index;
drop index cse532.facilityId_index;


create index cse532.facilityGeo_index on cse532.facility(geolocation) extend using db2gse.spatial_index(0.85, 2, 5);

create index cse532.zip_shape_index on cse532.uszip(shape) extend using db2gse.spatial_index(0.85, 2, 5);
create index cse532.zip_geoId_index on cse532.uszip(GEOID10);
create index cse532.facilityId_index on cse532.facility(ZIPCODE);

create index cse532.facilitycerf_attriValue_index on cse532.FACILITYCERTIFICATION(ATTRIBUTEVALUE);

runstats on table cse532.facility and indexes all;
runstats on table cse532.FACILITYCERTIFICATION and indexes all;
runstats on table cse532.uszip and indexes all;