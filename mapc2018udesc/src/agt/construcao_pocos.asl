+!buildPoligon :    name(AG) & 
					not lastMotorcycle(AG)
	<- true.

+!buildPoligon:  	name(AG) &
					lastMotorcycle(AG)  
	<-
		.wait(step(10));
	
		for(chargingStation(_,X,Y,_)) {
			addPoint(X,Y);
		}
		for(dump(_,X,Y)) {
			addPoint(X,Y);
		}
		for(shop(_,X,Y)) {
			addPoint(X,Y);
		}
		for(workshop(_,X,Y)) {
			addPoint(X,Y);
		}
		for(storage(_,X,Y,_,_,_)) {
			addPoint(X,Y);
		}
		buildPolygon;
//		.print("Poligono pronto !!");
		?betterWell(WELL);
		?lastCar(LASTCAR);
		.send(LASTCAR,achieve,buildWell( WELL, AG, 2, 9 ));
		!buildWell( WELL, AG, 4, 9 );
		.print("WELL: ",WELL);
	.

//+massium(M):M>4000 & not pocosExtra
//				   & lastMotorcycle(AG)
//				   & not task(cuidaPoco,_,_,_)
//	<-
//		?betterWell(WELL);	
//		!buildWell( WELL, AG, 2, 9 );
//		+pocosExtra;
//	.
//	
//+massium(M):M>4000 & not pocosExtra
//				   & lastCar(AG)
//				   & not task(cuidaPoco,_,_,_)
//	<-
//		?betterWell(WELL);
//		!buildWell( WELL, AG, 4, 9 );
//		+pocosExtra;
//	.

//+massium(M): not well(_,_,_,_,T,_) 				&
//			 team(T)							& 		
//		     (lastMotorcycle(AG) | lastCar(AG)) &
//		     step(S) & S>200 					& 
//		     not waitingMassium  				
//	<-
//		!removeTask(cuidaPoco,_,_,_);
//		?betterWell(WELL);
//		+waitingMassium;	
//		.wait(M>4000);
//		-waitingMassium;
//		if(lastMotorcycle(AG)) {
//			!buildWell( WELL, AG, 2, 9 );
//		}
//		else {
//			!buildWell( WELL, AG, 4, 9 );		
//		}
//	
//	.


/**
 * Plano que deve ser chamado quando ser quer
 * construir o poco no canto superior esquerdo.
 */
 
+!buildWell( WELLTYPE, AGENT, 1, PRIORITY )
	:	maxLat( MLAT )
	&	maxLon( MLON )
	<-	
		!buildWell( WELLTYPE, AGENT, MLAT, MLON, PRIORITY );
	.

/**
 * Plano que deve ser chamado quando ser quer
 * construir o poco no canto superior direita.
 */
+!buildWell( WELLTYPE, AGENT, 2, PRIORITY )
	:	maxLat( MLAT )
	&	minLon( MLON )
	<-	
		!buildWell( WELLTYPE, AGENT, MLAT, MLON, PRIORITY );
	.

/**
 * Plano que deve ser chamado quando ser quer
 * construir o po�o no canto inferior direito.
 */
+!buildWell( WELLTYPE, AGENT, 3, PRIORITY )
	:	minLat( MLAT )
	&	minLon( MLON )
	<-	!buildWell( WELLTYPE, AGENT, MLAT, MLON, PRIORITY );
	.

/**
 * Plano que deve ser chamado quando ser quer
 * construir o poco no canto inferior esquerdo.
 */
+!buildWell( WELLTYPE, AGENT, 4, PRIORITY )
	:	minLat( MLAT )
	&	maxLon( MLON )
	<-	!buildWell( WELLTYPE, AGENT, MLAT, MLON, PRIORITY );
	.

/**
 * Plano que constroi a lista de passos para a construcao de pocos
 */
+!buildWell( WELLTYPE, AGENT, LAT, LON, PRIORITY )
	:	true
	<-	 
		getPoint( LAT, LON, P );
		!getCoordenadasPonto( P, PLAT, PLON );
		!qtdStep( WELLTYPE, AGENT, QTD );
		
		!buildWellSteps( [goto(PLAT, PLON), build(WELLTYPE)], QTD, R );
		
		!addtask(buildWell,PRIORITY,R,[]);
		!buildCareWell(WELLTYPE);
//		.print( "buildWell pronto!!" );
	.
/**
 * Plano que pega a crenca point(lat,lon) fornecida pelo
 * artefato ARTGreyZone e retorna os valores de suas coordenadas.
 */
+!getCoordenadasPonto( point( PLAT, PLON ), LAT, LON )
	:	true
	<-	LAT = PLAT;
		LON = PLON;
	.

/**
 * Calcula quantos steps sao necessarios para construir um poco
 * levando em conta o skill do agente e o tipo de pocos
 */
+!qtdStep( WELLTYPE, AGENT, QTD )
	:	wellType(WELLTYPE,_,_,MIN,MAX)
	&	role(_,_,_,_,_,CURRENTSKILL,_,_,_,_,_)
	<-	
	
		QTD = math.ceil(( MAX-MIN )/CURRENTSKILL );
		.print("INTEGRIDADE ",(MAX-MIN)," CURRENT SKILL ",CURRENTSKILL," QTD ",QTD);
		//.print("WellType: ", WELLTYPE, ", MIN: ", MIN, ", MAX: ", MAX, ", QTD:", QTD, ", MINSKILL: ", MINSKILL);
	.

/**
 * Constroi uma lista com a instrucao build.
 * o tamanho dessa lista com o numero de vezes que o agente
 * tem que dar o build com construir o po�o.
 * Esse plano utiliza a recursividade. Ver plano abaixo.
 */
+!buildWellSteps( LS, QTD, R )
	:	QTD > 0
	<-	.concat( LS, [build], NLS );
		!buildWellSteps( NLS, QTD-1, R );
	.

/**
 * Caso em que a contagem de build's j� zerou.
 * Ver plano acima.
 */
+!buildWellSteps( LS, 0, R )
	:	true
	<-
		R = LS;
	.


+!buildCareWell (WELL): true
	<-
		+task(cuidaPoco,8.9,[noAction],[]);
	.
	
//Quando o inimigo chegar perto destruir o poco
+entity(_,TEAMADV,_,_,_)[source(percept)]:
			team(TEAM) 												&
			TEAMADV \==TEAM 										&
			name(AGENT)												&	
			(lastMotorcycle(AGENT)|lastCar(AGENT))					&
			task(cuidaPoco,_,_,_)									&
			doing(cuidaPoco) 										&
			not task(desmantelar,_,_,_)								&			
			betterWell(WELLTYPE) 									&
			wellType(WELLTYPE,_,_,_,INTEGRIDADE)   					& 
			role(_,_,_,_,_,CURRENTSKILL,_,_,_,_,_)
	<-

		QTD = math.ceil( INTEGRIDADE/CURRENTSKILL );
	
		?repeat( dismantle, QTD, [], R );
		!removetask(cuidaPoco,_,_,_);
		!addtask(desmantelar,9.1,R,[]);
	.

+!testDismantle :   task(desmantelar,_,_,_) 								& 
					name(AGENT)												&	
					(lastMotorcycle(AGENT)|lastCar(AGENT))     				&
					betterWell(WELLTYPE) 									&
					(not wellType(WELLTYPE,_,_,_,_)[source(percept)])
	<- 
		!removetask(desmantelar,_,_,_);
		-pocosExtra;
	.	


+!testDismantle <- true.	