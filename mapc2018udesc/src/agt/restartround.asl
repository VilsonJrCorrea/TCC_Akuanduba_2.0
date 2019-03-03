roundnumber(0).


//@start[atomic]
+simStart: not started 
		<-
				+started;				
				
				.wait(role(VEHICLE,_,_,_,_,_,_,_,_,_,_) &
					name(AGENT));					
				.broadcast(tell,partners(VEHICLE,AGENT));		
			
				!agentnumber;
				.wait(.count(partners(_,_),33));
				//.wait(step(2));
				!lastcar;
				!lastmotorcycle;
				
				!!buildPoligonToWells;
				!!buildPoligonToStorages;
				!!sendcentrals;
				!!exploration;
				
				!!callcraftSemParts;							
				!callCraftComPartsWithDelay;
				//!upgradelasttruck;
					
				!fastgathering;	
				
		.

+!lastcar:  whoislastcar(ME)& name(ME)
	<-
		+lastCar(ME)
		.print("LAST CAR: ",ME);
		.broadcast(tell,lastCar(ME));
	.

+!lastcar <- true.
		
+!lastmotorcycle : whoislastmotorcycle(ME) & name(ME)
	<-
		+lastMotorcycle(ME);
		.print("LAST MOTORCYCLE: ",ME);
		.broadcast(tell,lastMotorcycle(ME));
	.
	
+!lastmotorcycle <-true.
		
+!agentnumber: true
	<-
		?name(N);
//		?team(T);
//		jia.upper(T,BIGT);		
//		.concat("agent",BIGT,D);
		.delete("akuanduba_udesc",N,R);
		//.print(R);
		+agentid(R);
	.

+!sendcentrals
	:	agentid("20")
	<-	
		.wait(step(X) & X>0 & X<998);
		?centerStorageRule(STORAGE); 
		+centerStorage(STORAGE);
		?centerWorkshopRule(WORKSHOP);
		+centerWorkshop(WORKSHOP);
		.broadcast(tell, centerWorkshop(WORKSHOP) );
		.broadcast(tell, centerStorage(STORAGE) );
.

+!sendcentrals : not agentid("20")
	<- true.
	
//==================================================================
+!sendDistribution
	:	agentid("20")
	<-	
		.wait(step(20));
//		?howManyStorage(P);
		!buildPolygonOfStorages;

		!choiceStorages(P,LISTA);
	.

+!buildPolygonOfStorages:true
	<-
		for(storage(_,X,Y,_,_,_)) {
			addPoint(X,Y);
		}
		buildPolygon;
		.print("Poligono restart round pronto !!");
		getPolygon(POLYGON);
		.print("---------->",POLYGON);
		getMidPointOfPolygon(MIDPOINT);
		.print("==========|======== ",MIDPOINT);
	.
+!sendDistribution : not agentid("20")
	<- true.


+!choiceStorages(QTD,LISTA): true
	<-
		?mountList(QTD,0,[],LIST);
		.broadcast(tell, storages(LIST) );
	.	



//==============================================================
//@end[atomic]
+simEnd: not simEnded & roundnumber(RN)
	<-
		+simEnded;	
		
		.drop_all_events;		
   		.drop_all_intentions;
   		.drop_all_desires;
	
		.abolish(resourceNode(_,_,_,_));
		.abolish(centerStorage(_));
		.abolish(centerWorkshop(_));
		.abolish(chargingStation(_,_,_,_));
		.abolish(doing(_));
		.abolish(lastDoing(_));
		.abolish(laststep(_));	
		.abolish(numberTotalCraft(_));
		.abolish(numberAgRequired(_,_));	
		.abolish(waiting(_,_));
		.abolish(ponto(_,_));
		.abolish(demanded_assist(_));
		.abolish(lockhelp);
		.abolish(dependencelevel(_,_));
		.abolish(task(_,_,_,_));
//		.abolish(steps(_,_));
		
		-+roundnumber(RN+1);
		resetBlackboard(RN+1);		
		
		.abolish(started);			
	.
	
	
+steps(S): step(S-1)
<-
	.abolish(simEnded);	
.
