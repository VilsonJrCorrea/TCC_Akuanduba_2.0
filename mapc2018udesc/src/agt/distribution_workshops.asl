+!buildPoligonToWorkshops
	:	agentid("21")
	<-	
		.wait(step(10));
		for(workshop(NAME,X,Y)) {
			addPoint(NAME,X,Y);
		}
		buildPolygonForWorkshop;
		?maxLat(MAXLAT);
		?maxLon(MAXLON);
		?minLat(MINLAT);
		?minLon(MINLON);
		addBordas(MINLAT,MAXLAT,MINLON,MAXLON);
		getPolygonOfWorkshops(POLYGON);
		getPointsOfPolygon(POINTS);
		getPointsOfPolygonAdjusted(POINTSADJUSTED);
		.print("WORKSHOP - Pontos sem ajuste ",POINTS);
		.print("WORKSHOP - Pontos ajustados ",POINTSADJUSTED);
		.broadcast(tell, POINTSADJUSTED );	
	.
+!buildPoligonToWorkshops : not agentid("21")
	<- true.

