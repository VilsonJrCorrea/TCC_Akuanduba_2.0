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
	&	not (lastMotorcycle(NAME)|lastCar(NAME)) 
	&	step(STEPATUAL) & STEPATUAL>119
    &	role(ROLE,_,_,CAPACIDADE,_,_,_,_,_,_,_)
	
	&	sumvolruleJOB( ITENSJOB, VOLUMETOTAL )
	&	CAPACIDADE >= VOLUMETOTAL
	&	possuoTempoParaRealizarJob( NOMEJOB, TEMPONECESSARIO )
	&	TEMPONECESSARIO <= ( STEPFINAL - STEPATUAL )
    <- 
    	addIntentionToDoJob(NAME, NOMEJOB);
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
		?centerStorage(STORAGE);
		?job(NOMEJOB,LOCALENTREGA,REWARD,STEPINICIAL,STEPFINAL,ITENS);
		PASSOS_1 = [ goto( STORAGE ) ];
		?passosRetrieve( ITENS, [], RETORNO );
		.concat( PASSOS_1, RETORNO, PASSOS_2);
		?buildStore( [], DEVOLVERITEMS);
		.concat( [goto(STORAGE)],DEVOLVERITEMS, PASSOS_2, [ goto( LOCALENTREGA ), deliver_job( NOMEJOB )], PASSOS_3);
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
