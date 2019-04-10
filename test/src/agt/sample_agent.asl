//storage(storage1, lat, lon, cap, used, [item(name1, stored1, delivered1)]).
storage(storage0,48.8242,2.30026,10271,0,[item(item3,_,_),item(item1,_,_),item(item2,_,_),item(item11,_,_)]).
storage(storage1,48.82745,2.3717,11049,0,[item(item1,_,_),item(item3,_,_)]).
storage(storage2,48.86243,2.30345,9401,0,[item(item1,_,_),item(item3,_,_),item(item2,_,_)]).
storage(storage3,48.86627,2.40691,9797,0,[item(item1,_,_),item(item3,_,_)]).
storage(storage4,48.86627,2.40691,9797,0,[item(item1,_,_),item(item3,_,_)]).
storage(storage5,48.86627,2.40691,9797,0,[item(item1,_,_),item(item3,_,_),item(item2,_,_)]).
storage(storage6,48.86627,2.40691,9797,0,[item(item1,_,_),item(item3,_,_)]).
storage(storage7,48.86627,2.40691,9797,0,[item(item1,_,_),item(item2,_,_),item(item10,_,_)]).

pointsPolygonStorage([
	storage(storage5,48.86627,2.40691,2.835612185667537),
	storage(storage7,48.86627,2.40691,3.253684995837596),
	storage(storage0,48.8242,2.30026,5.478032482727152),
	storage(storage2,48.86243,2.30345,7.557277571858864)
]).
lat(48.89999).
lon(2.40999).
item(item2,_,_).
job(job0,storage5,384,1,67,[required(item10,1),required(item11,2),required(item5,1),required(item7,1),required(item9,1)]).
itensXPTO([item(item2,_,_),item(item2,_,_),item(item2,_,_)]).
!start.

+!start : true 
	<-	
		?job(_,_,_,_,_,LISTITENS);
		!stepsToGET(LISTITENS,STEPS1);
//		.print(STEPS1);
		
		?itensXPTO(LIST);		
		!stepsToPOST(LIST,STEPS2);
//		.print(STEPS2);
	.

+!stepsToGET(LISTITENS,STEPS):true
	<-
		?buildStepsToGET( LISTITENS, [], R);
		.print("Antes ",R)
		?limpaLista(R,vazio,[],STEPS);
		.print("Depois ",STEPS)
.

+!stepsToPOST(LIST,STEPS):true
	<-
		?buildStepsToPOST( LIST, [], R);
		.print("Antes ",R)
		?limpaLista(R,vazio,[],STEPS);
		.print("Depois ",STEPS)
.

buildStepsToGET( [], LISTA, RETORNO ) :- RETORNO = LISTA.

buildStepsToGET( [required(ITEM, QTD)|T], LISTA, RETORNO ):-
		 repeat( retrieve(ITEM,1) , QTD , [] ,RR )
		& whatStorageUseToGET(ITEM,R1)
		& .concat(LISTA,[goto(R1)],NNLISTA)
		& .concat(NNLISTA, RR, N_LISTA) 
		& buildStepsToGET( T, N_LISTA, RETORNO)
	.

buildStepsToPOST( [], LISTA, RETORNO ) :- RETORNO = LISTA.

buildStepsToPOST( [item(ITEM, _,_)|T], LISTA, RETORNO ):-
		 repeat( store(ITEM,1) , 1 , [] ,RR )
		& whatStorageUseToPOST(ITEM,R1)
		& .concat(LISTA,[goto(R1)],NNLISTA)
		& .concat(NNLISTA, RR, N_LISTA) 
		& buildStepsToPOST( T, N_LISTA, RETORNO)
	.

//IGNORA REPETIDO
limpaLista([OP|T],GT,TMP,R) :- not (goto(_)=OP) 
							   & .concat(TMP,[OP],TMP2) 
							   & limpaLista(T,GT,TMP2,R).

//ADICIONA UM GOTO DIFERENTE
limpaLista([GT1|T],GT,TMP,R) :- GT\==GT1
								& .concat(TMP,[GT1],TMP2)
							    & limpaLista(T,GT1,TMP2,R).

//IGNORA GOTO REPETIDO
limpaLista([GT1|T],GT,TMP,R) :- GT==GT1 
								& limpaLista(T,GT,TMP,R).

//CONDICAO DE PARADA
limpaLista([],GT,TMP,TMP):-true.


repeat(TERM , QTD , L ,RR ) :- QTD> 0 & repeat(TERM , QTD-1 , [TERM|L] , RR). 						
repeat(TERM , QTD , L ,L ):-true.

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
	//&.print("É atom. O estoque mais proximo é o ",RESPOSTA)
.

validaResposta(LIST, RESPOSTA,R):-
	not .atom(RESPOSTA)
	& retornaOMaisProximo(LIST,100000,RESPOSTA,R)
	//& .print("Não é atom. Indo para o mais proximo ",R)
.

validaMenorDistancia(X,Y,P):-X>Y& P=Y.
validaMenorDistancia(X,Y,P):-X<=Y&P=X.

validaName(X,Y,NAME,NAMEATUAL,P):- X>Y  & P = NAME.
validaName(X,Y,NAME,NAMEATUAL,P):- X<=Y & P = NAMEATUAL.
				
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

