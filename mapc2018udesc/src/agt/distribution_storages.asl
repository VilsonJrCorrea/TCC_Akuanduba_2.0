+!buildPoligonToStorages
	:	agentid("20")
	<-	
		.wait(step(10));
		for(storage(NAME,X,Y,_,_,_)) {
			addPoint(NAME,X,Y);
		}
		buildPolygonForStorages;
		.print("Poligono restart round pronto !!");
		getPolygonOfStorages(POLYGON);
		.print("---------->",POLYGON);
		getPointsOfPolygon(POINTS);
		.print("==========|======== ",POINTS);
		.broadcast(tell, POINTS );
		
	.
+!buildPoligonToStorages : not agentid("20")
	<- true.

