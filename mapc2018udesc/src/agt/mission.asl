passosRetrieve( [], LISTA, RETORNO ) :- RETORNO = LISTA.

passosRetrieve( [required(ITEM, QTD)|T], LISTA, RETORNO ):-
repeat( retrieve(ITEM,1) , QTD , [] ,RR ) &
		.concat(LISTA, RR, N_LISTA) &
		passosRetrieve( T, N_LISTA, RETORNO).

//@mission[atomic]
+mission(NOMEMISSION,LOCALENTREGA,RECOMPENSA,STEPINICIAL,STEPFINAL,DESCONHECIDO1,DESCONHECIDO2,_,ITENS)
	:
		name( NAME )
	&	not jobCommitment(NAME,_)
	&	not gatherCommitment( NAME, _ )
	&	not craftCommitment( NAME, _ )
	& 	not (lastMotorcycle(NAME)|lastCar(NAME))
	&	not missionCommitment( NAME, _ )
	&	step(STEPATUAL) & STEPATUAL>119
    &	role(ROLE,_,_,CAPACIDADE,_,_,_,_,_,_,_)
	&	sumvolruleJOB( ITENS, VOLUMETOTAL )
	&	CAPACIDADE >= VOLUMETOTAL
    <- 
    !possuoTempoParaRealizarMISSION( NOMEMISSION, TEMPONECESSARIO );
    	if(TEMPONECESSARIO <= ( STEPFINAL - STEPATUAL )){
	    	addIntentionToDoMission(NAME, NOMEMISSION);
    	}
  .
 
+domission( NOMEMISSION )
	:
		role(ROLE,_,_,_,_,_,_,_,_,_,_)
    <-
    	.print( "Eu, um(a) ", ROLE, " vou fazer a mission ", NOMEMISSION );
    	!dropAll;
    	!removetask(fastgathering,_,_,_);
    	!!realizarMission( NOMEMISSION );
	.


+!possuoTempoParaRealizarMISSION( NOMEMISSION, TEMPONECESSARIO )
	<-
		?mission(NOMEMISSION,LOCALENTREGA,_,STEPINICIAL,STEPFINAL,_,_,_,ITENS);
		!stepsToGET(ITENS,STEPS);
		?getHeadOfSteps(STEPS,COMMAND);
		?getNameStorageGoTo(COMMAND,STORAGE);
		?storage( STORAGE, STORAGELAT, STORAGELON, _, _, _);
		?storage( LOCALENTREGA, DESTINOLAT, DESTINOLON, _, _, _)
		?lat( MEULAT )
		?lon( MEULON )
		?calculatedistance( MEULAT, MEULON, STORAGELAT, STORAGELON, DISTANCIASTORAGE )
		?distanciasemsteps( DISTANCIASTORAGE, STEPSSTORAGE )
		?calculatedistance( STORAGELAT, STORAGELON, DESTINOLAT, DESTINOLON, DISTANCIADESTINO )
		?distanciasemsteps( DISTANCIADESTINO, STEPSDESTINO )
		?qtdItens( ITENS, 0, NUMEROITENS )
		TEMPONECESSARIO = ( NUMEROITENS + STEPSDESTINO + STEPSSTORAGE + 10)
	.

//@realizarMissionSimples[atomic]
+!realizarMission( NOMEMISSION )
	:
//		whatStorageUse(STORAGE)
		mission(NOMEMISSION,LOCALENTREGA,RECOMPENSA,STEPINICIAL,STEPFINAL,DESCONHECIDO1,DESCONHECIDO2,_,ITENSMISSION)
	<-	
//		PASSOS_1 = [ goto( STORAGE ) ];
//		?passosRetrieve( ITENSMISSION, [], RETORNO );
//		.concat( PASSOS_1, RETORNO, PASSOS_2);
		!stepsToGET(ITENSMISSION,STEPS);
		.concat( STEPS, [ goto( LOCALENTREGA ), deliver_job( NOMEMISSION )], PASSOS_3);
		
		!addtask(mission,9,PASSOS_3,[]);
	.

+!realizarMission( NOMEMISSION )
	:
	true
	<-	
		.print( "Alguma coisa deu errado com o realizarMission e caiu aqui." );
	.


+!testarMission
	:
		name( NAME )
	&	missionCommitment( NAME,MISSION )
	&	not mission(MISSION,_,_,_,_,_,_,_,_)
	&	step( STEP )
	<-
		.print( STEP, "-Acabou o tempo para eu fazer a mission ", MISSION);
		!dropAll;
		removeIntentionToDoMission( NAME, MISSION );
		!removetask(mission,_,_,_);
	.


+!testarMission<-true.

-task(mission,_,[_|[]],_)
	: 	jobCommitment(NAME,NOMEMISSION) &
		name( NAME )				&
		role(ROLE,_,_,_,_,_,_,_,_,_,_)
	<-
		.print("entregou mission");
		removeIntentionToDoMission(NAME, NOMEMISSION);
	.
