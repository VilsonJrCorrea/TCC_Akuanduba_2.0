//storage(storage1, lat, lon, cap, used, [item(name1, stored1, delivered1)]).
storage(storage0,48.8242,2.30026,10271,0,[item(item3,_,_),item(item1,_,_),item(item2,_,_)]).
storage(storage1,48.82745,2.3717,11049,0,[item(item1,_,_),item(item3,_,_)]).
storage(storage2,48.86243,2.30345,9401,0,[item(item1,_,_),item(item3,_,_),item(item2,_,_)]).
storage(storage3,48.86627,2.40691,9797,0,[item(item1,_,_),item(item3,_,_)]).
storage(storage4,48.86627,2.40691,9797,0,[item(item1,_,_),item(item3,_,_)]).
storage(storage5,48.86627,2.40691,9797,0,[item(item1,_,_),item(item3,_,_),item(item2,_,_)]).
storage(storage6,48.86627,2.40691,9797,0,[item(item1,_,_),item(item3,_,_)]).
storage(storage7,48.86627,2.40691,9797,0,[item(item1,_,_),item(item2,_,_)]).

pointsPolygonStorage([
	storage(storage5,48.86627,2.40691,2.835612185667537),
	storage(storage7,48.86627,2.40691,3.253684995837596),
	storage(storage0,48.8242,2.30026,5.478032482727152),
	storage(storage2,48.86243,2.30345,7.557277571858864)
]).
lat(48.89999).
lon(2.40999).
item(item2,_,_).

!start.


+!start : true 
	<-	
		?item(NAMEITEM,_,_);
		?whatStorageUseToGET(NAMEITEM,R1);
		.print("RESPOSTA GET ",R1);
		
		?whatStorageUseToPOST(NAMEITEM,R2);
		.print("RESPOSTA POST ",R2);
	.


whatStorageUseToPOST(NAMEITEM, RESPOSTA)
	:-	
		pointsPolygonStorage(LIST) 
		& percorreListaStorageToPOST(LIST,NAMEITEM,ESTOQUES,10000,STORAGE,ESTOQ)
		& validaResposta(LIST,ESTOQ,RESPOSTA)
	.

whatStorageUseToGET(NAMEITEM, RESPOSTA)
	:-	
		pointsPolygonStorage(LIST) 
		& percorreListaStorageToGET(LIST,NAMEITEM,ESTOQUES,10000,STORAGE,ESTOQ)
		& validaResposta(LIST,ESTOQ,RESPOSTA)
	.

percorreListaStorageToGET([H|T], NAMEITEM, ESTOQUES,DISTANCIA,NOMEMELHORSTORAGE,R):-
										 desmontaItemListaStorage(H,NAMEATUAL,LATDESTINO,LONDESTINO) 
										 & lat(LATATUAL)		
										 & lon(LONATUAL)
										 & getStorage(NAMEATUAL,ITENSDEPOSITADOS)
										 & containsItens(NAMEITEM,ITENSDEPOSITADOS,0,RESULTADO)
										 & 	((RESULTADO>0 
										 	 & calculatedistance(LATATUAL,LONATUAL,LATDESTINO,LONDESTINO,DISTANCIACALCULADA) 
										 	 & validaMenorDistancia(DISTANCIACALCULADA,DISTANCIA,MENORDISTANCIA)
										 	 & validaName(DISTANCIACALCULADA,DISTANCIA,NOMEMELHORSTORAGE,NAMEATUAL,NOVOMELHORSTORAGE)
										 	 & percorreListaStorageToGET(T,NAMEITEM,ESTOQUES,MENORDISTANCIA,NOVOMELHORSTORAGE,R)
										 	 )
										 									|
										  (RESULTADO==0 
										  	& percorreListaStorageToGET(T,NAMEITEM,ESTOQUES,DISTANCIA,NOMEMELHORSTORAGE,R)
										  ))
								.
					
percorreListaStorageToGET([],ITENS,ESTOQUES,DISTANCIA,MELHORSTORAGE, R):-  R=MELHORSTORAGE.	
			
			
percorreListaStorageToPOST([H|T], NAMEITEM, ESTOQUES,DISTANCIA,NOMEMELHORSTORAGE,R):-
										 desmontaItemListaStorage(H,NAMEATUAL,LATDESTINO,LONDESTINO) 
										 & lat(LATATUAL)		
										 & lon(LONATUAL)
										 & getStorage(NAMEATUAL,ITENSDEPOSITADOS)
										 & containsItens(NAMEITEM,ITENSDEPOSITADOS,0,RESULTADO)
										 & 	((RESULTADO==0 
										 	 & calculatedistance(LATATUAL,LONATUAL,LATDESTINO,LONDESTINO,DISTANCIACALCULADA) 
										 	 & validaMenorDistancia(DISTANCIACALCULADA,DISTANCIA,MENORDISTANCIA)
										 	 & validaName(DISTANCIACALCULADA,DISTANCIA,NOMEMELHORSTORAGE,NAMEATUAL,NOVOMELHORSTORAGE)
										 	 & percorreListaStorageToPOST(T,NAMEITEM,ESTOQUES,MENORDISTANCIA,NOVOMELHORSTORAGE,R)
										 	 )
										 									|
										  (RESULTADO\==0 
										  	& percorreListaStorageToPOST(T,NAMEITEM,ESTOQUES,DISTANCIA,NOMEMELHORSTORAGE,R)
										  ))
								.
					
percorreListaStorageToPOST([],ITENS,ESTOQUES,DISTANCIA,MELHORSTORAGE, R):-  R=MELHORSTORAGE.	
			
retornaOMaisProximo([H|T],DISTANCIA,MELHORSTORAGE,R):-
										 desmontaItemListaStorage(H,NAMEATUAL,LATDESTINO,LONDESTINO) &
										 lat(LATATUAL) &
										 lon(LONATUAL) &
										 calculatedistance(LATATUAL,LONATUAL,LATDESTINO,LONDESTINO,DISTANCIACALCULADA) &
										 validaMenorDistancia(DISTANCIACALCULADA,DISTANCIA,MENORDISTANCIA)&
										 validaName(DISTANCIACALCULADA,DISTANCIA,MELHORSTORAGE,NAMEATUAL,NOVOMELHORSTORAGE)&
										 retornaOMaisProximo(T,MENORDISTANCIA,NOVOMELHORSTORAGE,R)
								.
								
retornaOMaisProximo([],DISTANCIA,MELHORSTORAGE,R):- R=MELHORSTORAGE.	
								
getStorage(NAME,RESPOSTA):- storage(NAME,_,_,_,_,ITENS) & RESPOSTA=ITENS.

containsItens(NAMEITEM,[H|T],CONT,R):- getNameItem(H,NAME) &
									((NAME==NAMEITEM &AUX=CONT+1 & containsItens(NAMEITEM,T,AUX,R))	| 
									 (NAME\==NAMEITEM & containsItens(NAMEITEM,T,CONT,R)))
									
					.
containsItens(NAMEITEM,[],CONT,R):-R=CONT.

getNameItem(item(NAME,_,_),NAME):-true.

desmontaItemListaStorage(storage(NAME,LAT,LON,RAIO),NNAME,LLAT,LLON):- 
					NNAME=NAME &
					LLAT=LAT &
					LLON=LON
		.
		
calculatedistance( XA, YA, XB, YB, DISTANCIA )
					:- DISTANCIA =  math.sqrt((XA-XB)*(XA-XB)+(YA-YB)*(YA-YB)).
	

validaResposta(LIST, RESPOSTA,RESPOSTA):-
	.atom(RESPOSTA)
	&.print("É atom. O estoque mais proximo é o ",RESPOSTA)
.

validaResposta(LIST, RESPOSTA,R):-
	not .atom(RESPOSTA)
	& retornaOMaisProximo(LIST,100000,RESPOSTA,R)
	& .print("Não é atom. Indo para o mais proximo ",R)
.

validaMenorDistancia(X,Y,P):-X>Y& P=Y.
validaMenorDistancia(X,Y,P):-X<=Y&P=X.

validaName(X,Y,NAME,NAMEATUAL,P):- X>Y  & P = NAME.
validaName(X,Y,NAME,NAMEATUAL,P):- X<=Y & P = NAMEATUAL.
				
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

