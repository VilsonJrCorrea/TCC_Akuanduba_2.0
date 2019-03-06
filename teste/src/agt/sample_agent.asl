//lat(48.86292).
//lon(2.31723).
//=========================================
//lat(48.84688).
//lon(2.32036).
//=========================================
//lat(48.87787).
//lon(2.26824).
//=========================================
//lat(48.89927).
//lon(2.367).
//=========================================
//lat(48.88411).
//lon(2.38417).
//=========================================
//
//lat(48.8858). lon(2.27265).
//=========================================
//lat(48.89504). lon(2.39389).
////=========================================
//lat(48.84198). lon(2.39812).
////=========================================
lat(48.85247). lon(2.28629).
////=========================================

pointsOfPolygon([
	storage(storage4,48.88148,2.27002,6.05638845033937),
	storage(storage7,48.88509,2.40376,4.188439003541811),
	storage(storage1,48.82957,2.32677,4.866228800959661),
	storage(storage0,48.85842,2.27773,5.525451488889527),
	storage(storage2,48.83586,2.37935,4.353046834440818)]).

!start.


+!start : true <-
	 .print("hello world.");
	 ?whatStorageUse(STORAGE);
	 .print(STORAGE);
	 
.
					
whatStorageUse(R):-
	pointsOfPolygon(LIST) &
	percorreLista(LIST,100000,STORAGE,R) 
.					

percorreLista([H|T],DISTANCIA,MELHORSTORAGE,R):-
										 desmontaItemLista(H,NAMEATUAL,LATDESTINO,LONDESTINO) &
										 lat(LATATUAL) &
										 lon(LONATUAL) &
//										 .print("h ",NAMEATUAL," lon ",LATDESTINO," lat ",LONDESTINO)&
										 calculatedistance(LATATUAL,LONATUAL,LATDESTINO,LONDESTINO,DISTANCIACALCULADA) &
//										 .print("Distancia ",DISTANCIA, " Distancia calculada ",DISTANCIACALCULADA)&
										 validaMenorDistancia(DISTANCIACALCULADA,DISTANCIA,MENORDISTANCIA)&
//										 .print("||||||||Menor distancia validadda com sucesso para ",NAMEATUAL)&
										 validaNameStorage(DISTANCIACALCULADA,DISTANCIA,MELHORSTORAGE,NAMEATUAL,NOVOMELHORSTORAGE)&
//										  .print("============Nome validado com sucesso para ",NOVOMELHORSTORAGE)&
//										 .print(
//										 	" LAT ATUAL ",LATATUAL,
//										 	" LON ATUAL ",LONATUAL,
//										 	" MENOR DISTANCIA ",MENORDISTANCIA,
//										 	" MELHOR STORAGE ",MELHORSTORAGE) &
										 percorreLista(T,MENORDISTANCIA,NOVOMELHORSTORAGE,R)
								.
								
percorreLista([],DISTANCIA,MELHORSTORAGE,R):- R=MELHORSTORAGE.

validaMenorDistancia(X,Y,P):-X>Y& P=Y.
validaMenorDistancia(X,Y,P):-X<=Y&P=X.

validaNameStorage(X,Y,NAMESTORAGE,NAMEATUAL,P):- X>Y  & P = NAMESTORAGE.
validaNameStorage(X,Y,NAMESTORAGE,NAMEATUAL,P):- X<=Y & P = NAMEATUAL.
						

desmontaItemLista(storage(NAME,LAT,LON,RAIO),NNAME,LLAT,LLON):- 
					NNAME=NAME &
					LLAT=LAT &
					LLON=LON
		.

calculatedistance( XA, YA, XB, YB, DISTANCIA )
					:- DISTANCIA =  math.sqrt((XA-XB)*(XA-XB)+(YA-YB)*(YA-YB)).



					
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

