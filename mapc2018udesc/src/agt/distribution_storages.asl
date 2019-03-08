+!buildPoligonToStorages
	:	agentid("20")
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
		.broadcast(tell, POINTSADJUSTED );
		
	.
+!buildPoligonToStorages : not agentid("20")
	<- true.

