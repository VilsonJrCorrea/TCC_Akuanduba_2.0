//storage(storage1, lat, lon, cap, used, [item(name1, stored1, delivered1)]).
storage(storage0,48.8242,2.30026,10271,0,[item(item1,_,_),item(item3,_,_)]).
storage(storage1,48.82745,2.3717,11049,0,[item(item1,_,_)]).
storage(storage2,48.86243,2.30345,9401,0,[item(item1,_,_)]).
storage(storage3,48.86627,2.40691,9797,0,[item(item1,_,_)]).
storage(storage4,48.86627,2.40691,9797,0,[item(item1,_,_)]).
storage(storage5,48.86627,2.40691,9797,0,[item(item1,_,_),item(item2,_,_),item(item3,_,_)]).
storage(storage6,48.86627,2.40691,9797,0,[item(item1,_,_)]).
storage(storage7,48.86627,2.40691,9797,0,[item(item1,_,_)]).

pointsPolygonStorage([
	storage(storage5,52.53623,13.36245,2.835612185667537),
	storage(storage7,52.53999,13.47045,3.253684995837596),
	storage(storage0,52.46146,13.41117,5.478032482727152),
	storage(storage2,52.44276,13.47137,7.557277571858864)
]).
lat(48.89999).
lon(2.40999).
itens([item(item3,_,_)]).

!start.


+!start : true 
	<-	
		?itens(ITENS);
//		.print(ITENS);
		?whatStorageUseToGET(STORAGE,ITENS)
	.

//
whatStorageUseToGET(STORAGE,ITENS)
	:-
		pointsPolygonStorage(LIST) 
		& percorreListaStorage(LIST,ITENS,ESTOQUES,R)
		& .print(R, "  --------------  ",ESTOQUES," ------------")
	.


//Storage distribuido==========================================================================
percorreListaStorage([H|T], ITENSDESEJADOS, ESTOQUES,R):-
										 desmontaItemListaStorage(H,NAMEATUAL,LATDESTINO,LONDESTINO) 
										 & lat(LATATUAL)		
										 & lon(LONATUAL)
										 & getStorage(NAMEATUAL,ITENSDEPOSITADOS)
										 & containsItens(ITENSDESEJADOS,ITENSDEPOSITADOS,[],ITEMENCONTRADO)
										 & .length(ITEMENCONTRADO,QTDENCONTRADO)
										 & percorreListaStorage(T,ITENSDESEJADOS,ESTOQUES,R)
										 & temItem(QTDENCONTRADO,NAMEATUAL,RETORNO)
										 & put(RETORNO,ESTOQUES,R)	
								.
								
put(NAME,LIST,R):-.list(NAME) & inserirF(NAME,LIST,R).
put(NAME,LIST,R):-.print("FAIL EM ",NAME," LIST ",LIST," R ",R).

inserirF(E,[],[E]):-true.
inserirF(E,[H|T],R):- inserirF(E,T,RA) & R=[H|RA].






temItem(QTDENCONTRADO, NAMEATUAL, RETORNO):- QTDENCONTRADO==1 & RETORNO=[NAMEATUAL].
temItem(QTDENCONTRADO, NAMEATUAL,RETORNO):-true.						
								
percorreListaStorage([],ITENS,ESTOQUES,R):-  true.	
getStorage(NAME,RESPOSTA):- storage(NAME,_,_,_,_,ITENS) & RESPOSTA=ITENS.


containsItens([H|T],ITENSDEPOSITADOS,P,R):- ((.member(H,ITENSDEPOSITADOS) & .concat([H],P,R))
											| (not .member(H,ITENSDEPOSITADOS) &.concat([],P,R)))
											& containsItens(T,ITENSDEPOSITADOS,R,R)
					.
containsItens([],ITENSDEPOSITADOS,_,R):-true.


validaPossuiItens([H|T],LISTSTORAGES):- storage(NAME,_,_,_,_,LIST) &
											
											.member(H,LIST) &
											NOVOMELHORSTORAGE=NAME &
											.concat([],[NOVOMELHORSTORAGE],LISTSTORAGES)&
											validaPossuiItem(T,LISTSTORAGES)
										.

validaPossuiItens([],LISTSTORAGES):-LISTSTORAGES.


desmontaItemListaStorage(storage(NAME,LAT,LON,RAIO),NNAME,LLAT,LLON):- 
					NNAME=NAME &
					LLAT=LAT &
					LLON=LON
		.
		
calculatedistance( XA, YA, XB, YB, DISTANCIA )
					:- DISTANCIA =  math.sqrt((XA-XB)*(XA-XB)+(YA-YB)*(YA-YB)).
	

validaMenorDistancia(X,Y,P):-X>Y& P=Y.
validaMenorDistancia(X,Y,P):-X<=Y&P=X.

validaName(X,Y,NAME,NAMEATUAL,P):- X>Y  & P = NAME.
validaName(X,Y,NAME,NAMEATUAL,P):- X<=Y & P = NAMEATUAL.
				
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

