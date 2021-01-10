!erase D:\SEM2\TODB\assignment2\zip.msg;

DROP TABLE cse532.uszip;

--!erase D:\SEM2\TODB\assignment2\zip.msg;
 
!db2se import_shape sample
-fileName         D:\SEM2\TODB\assignment2\tl_2019_us_zcta510.shp
-srsName          nad83_srs_1
-tableSchema      cse532
-tableName        uszip
-spatialColumn    shape
-client           1
-messagesFile     D:\SEM2\TODB\assignment2\zip.msg
;
 
!db2se register_spatial_column sample
-tableSchema      cse532
-tableName        uszip
-columnName       shape
-srsName          nad83_srs_1
;
 
describe table cse532.uszip;
 
 

