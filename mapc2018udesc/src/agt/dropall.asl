+!dropAll
	:
		hasItem( _, _)
	&	whatStorageUse( STORAGE )
	<-
		?buildStore( [], LISTAFINAL );
		.concat( [goto(STORAGE)], LISTAFINAL, PASSOS );
		!addtask(dropAll,8.9,PASSOS,[]);
		//.print( "REMOVER ITENS CARREGADOS" );
	.

+!dropAll <-true.
