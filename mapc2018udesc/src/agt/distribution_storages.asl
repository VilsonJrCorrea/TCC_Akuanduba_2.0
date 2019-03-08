+!buildPoligonToStorages
	:	agentid("19")
	<-	
		.wait(step(10));
		for(storage(NAME,X,Y,_,_,_)) {
			addPoint(NAME,X,Y);
		}
		buildPolygonForStorages;
		?maxLat(MAXLAT);
		?maxLon(MAXLON);
		?minLat(MINLAT);
		?minLon(MINLON);
		addBordas(MINLAT,MAXLAT,MINLON,MAXLON);
		getPolygonOfStorages(POLYGON);
		getPointsOfPolygon(POINTS);
		getPointsOfPolygonAdjusted(POINTSADJUSTED);
		.print("Pontos sem ajuste ",POINTS);
		.print("Pontos ajustados ",POINTSADJUSTED);
		?getList(POINTSADJUSTED,LIST);
		.print("A---> ",POINTSADJUSTED);
		.print("B---> ",LIST);
		+pointsPolygonStorage(POINTSADJUSTED);
		.broadcast(tell, pointsPolygonStorage(POINTSADJUSTED) );
		
	.
+!buildPoligonToStorages : not agentid("19")
	<- true.

getList(POINTS,LIST):-
	LIST=POINTS
.