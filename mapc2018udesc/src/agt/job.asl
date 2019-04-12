passosRetrieve( [], LISTA, RETORNO ) :- RETORNO = LISTA.
passosRetrieve( [required(ITEM, QTD)|T], LISTA, RETORNO ):-
		repeat( retrieve(ITEM,1) , QTD , [] ,RR ) &
		.concat(LISTA, RR, N_LISTA) &
		passosRetrieve( T, N_LISTA, RETORNO).

//@job[atomic]
+job( NOMEJOB,LOCALENTREGA,REWARD,STEPINICIAL,STEPFINAL,ITENSJOB )
	:
		name( NAME )
	&	not jobCommitment(NAME,_)
	&	not gatherCommitment( NAME, _ )
	&	not craftCommitment( NAME, _ )
	&	not missionCommitment( NAME, _ )
	& 	not (lastMotorcycle(NAME)|lastCar(NAME))
	&   not amilastfreetruck(_) //teste
	&	step(STEPATUAL)
    &	role(ROLE,_,_,CAPACIDADE,_,_,_,_,_,_,_)
	&	sumvolruleJOB( ITENSJOB, VOLUMETOTAL )
	&	CAPACIDADE >= VOLUMETOTAL
	
    <- 
    	!possuoTempoParaRealizarJob( NOMEJOB, TEMPONECESSARIO );
    	if(TEMPONECESSARIO <= ( STEPFINAL - STEPATUAL )){
    		addIntentionToDoJob(NAME, NOMEJOB);	
    	}
  .
 
 +!possuoTempoParaRealizarJob( NOMEJOB, TEMPONECESSARIO )
	<-
		?job(NOMEJOB,LOCALENTREGA,REWARD,STEPINICIAL,STEPFINAL,ITENS);
		!stepsToGET(ITENS,STEPS);
		?getHeadOfSteps(STEPS,COMMAND);
		?getNameStorageGoTo(COMMAND,STORAGE);
		?storage( STORAGE, STORAGELAT, STORAGELON, _, _, _);
		?storage( LOCALENTREGA, DESTINOLAT, DESTINOLON, _, _, _);
		?lat( MEULAT )
		?lon( MEULON )
		?calculatedistance( MEULAT, MEULON, STORAGELAT, STORAGELON, DISTANCIASTORAGE );
		?distanciasemsteps( DISTANCIASTORAGE, STEPSSTORAGE );
 		?calculatedistance( STORAGELAT, STORAGELON, DESTINOLAT, DESTINOLON, DISTANCIADESTINO );
		?distanciasemsteps( DISTANCIADESTINO, STEPSDESTINO );
		?qtdItens( ITENS, 0, NUMEROITENS );
		TEMPONECESSARIO = ( NUMEROITENS + STEPSDESTINO + STEPSSTORAGE + 10);
	.
 

+dojob(NOMEJOB)
	:
		role(ROLE,_,_,_,_,_,_,_,_,_,_) 
    <-
    	?agentid(ID);
    	.print( "Eu, um(a) ", " id ",ID ," ", ROLE, " vou fazer o job ", NOMEJOB );
    	!!dropAll;
    	!!realizarJob( NOMEJOB );
	.

//@realizarJob[atomic]
+!realizarJob( NOMEJOB )
	:
		true
	<-	
//		?whatStorageUse(STORAGE);
		?job(NOMEJOB,LOCALENTREGA,REWARD,STEPINICIAL,STEPFINAL,ITENS);
		!stepsToGET(ITENS,STEPS);
		
//		PASSOS_1 = [ goto( STORAGE ) ];
//		?passosRetrieve( ITENS, [], RETORNO );
//		.concat( PASSOS_1, RETORNO, PASSOS_2);
		//?buildStore( [], DEVOLVERITEMS);
		//DEVOLVERITEMS
		.concat( STEPS, [ goto( LOCALENTREGA ), deliver_job( NOMEJOB )], PASSOS_3);
		!removetask(fastgathering,_,_,_);
		!addtask(job,5,PASSOS_3,[]);
	.

+!testarTrabalho
	:
		name( NAME )
	&	jobCommitment( NAME,JOB )
	&	not job( JOB,_,_,_,_,_ )
	&	step( STEP )
	<-
		.print( STEP, "-Acabou o tempo para eu fazer o job ", JOB );
    	!!dropAll;
		removeIntentionToDoJob( NAME, JOB );
		!removetask(job,_,_,_);
	.

+!testarTrabalho<-true.

-task(job,_,[_|[]],_)
	: 	jobCommitment(NAME,NOMEJOB) &
		name( NAME )				&
		role(ROLE,_,_,_,_,_,_,_,_,_,_)
	<-
		removeIntentionToDoJob(NAME, NOMEJOB);
	.
