create procedure MergeProc
LANGUAGE SQL 

begin
   
  declare curr_sum INTEGER;
  declare summa INTEGER;

  declare zipcode DOUBLE;
  declare average DOUBLE;
  
  declare cluster_id DOUBLE;
  
  declare poulation DOUBLE;
  

  
  create view TEMP_A(ZIPCODE,CLUSTER_ID,ZPOP)
		AS
		(
  		select SUBSTR( zshape.GEOID10,1,5) , -1 as CLUSTER_ID,zpopl.ZPOP  
		from cse532.uszip as zshape 
	    inner join ZIPPOP as zpopl on zshape.GEOID10=zpopl.GEOID
	    	where zpopl.ZPOP not in (0)
		  	--ORDER by zpopl.ZPOP
		  		--FETCH FIRST 1000 rows only
		);
	--select * from TEMP_A ;
	--declare c1 Cursor_table cursor for select * from TEMP_A;
	
	SET average = (select avg(ZPOP)  
						from TEMP_A
	     			);
	     			
	SET zipcode = 0;
	
	
	
	OPEN c1;
	
	FETCH FROM c1 INTO zipcode, cluster_id, population, shape;
	
	WHILE(SQLSTATE = '00000') DO
	SET curr_sum=0;
	if (cluster_id= -1) THEN
		DECLARE c2 CURSOR FOR 
				SELECT  a2.GEOID10 , a.population
					FROM cse532.uszip a1, cse532.uszip a2 , TEMP_A a
					WHERE 
					a.ZIPCODE=a1.GEOID10 
					db2gse.ST_Touches(a1.shape, a2.shape) = 1
					and a1.GEOID10 = zipcode
					
		DECLARE csum CURSOR FOR 
				SELECT  SUM(a.population) as summa
					FROM cse532.uszip a1, cse532.uszip a2 , TEMP_A a
					WHERE 
					a.ZIPCODE=a1.GEOID10 
					db2gse.ST_Touches(a1.shape, a2.shape) = 1
					and a1.GEOID10 = zipcode;
					
		FETCH FROM csum into summa;
		
		if (csum > average) THEN
		
			
		
			OPEN c2;
			FETCH FROM c2 INTO zipcode, cluster_id, population, shape;
			WHILE(SQLSTATE = '00000') DO


			update 	TEMP_A SET CLUSTER_ID=zipcode where TEMP_A.ZIPCODE=zipcode;
			FETCH FROM c2 INTO zipcode, cluster_id, population, shape;
			END WHILE;
			close C2;
			close csum
			
		END IF;
		
		
			
		FETCH FROM c1 INTO zipcode, cluster_id, population, shape;
	END IF;
	
	END WHILE;
	CLOSE c1;
end
@


