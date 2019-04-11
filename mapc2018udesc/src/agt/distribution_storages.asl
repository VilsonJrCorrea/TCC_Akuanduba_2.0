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
		!getList(POINTSADJUSTED,RETORNO);
		+pointsPolygonStorage(RETORNO);
		.broadcast(tell, pointsPolygonStorage(RETORNO) );
		
	.
+!buildPoligonToStorages : not agentid("19")
	<- true.

+!getList(pointsPolygonStorage(LIST),RETORNO):true
	<-
	RETORNO=LIST
.
+!stepsToGET(LISTITENS,STEPS):true
	<-
		?buildStepsToGET( LISTITENS, [], R);
.

+!stepsToPOST(LIST,STEPS):true
	<-
		?buildStepsToPOST( LIST, [], R);
.