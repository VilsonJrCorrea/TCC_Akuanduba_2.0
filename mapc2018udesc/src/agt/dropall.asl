+!dropAll :	hasItem( _, _)
	<-
		?buildListOfItens([],LISTAFINAL);
		!stepsToPOST(LISTAFINAL,PASSOS)
		!addtask(dropAll,8.9,PASSOS,[]);
	.

+!dropAll <-true.

