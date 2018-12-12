+!callcraftSemParts	:	role(truck,_,_,LOAD,_,_,_,_,_,_,_) 							  & 
					name(NAMEAGENT)					   							  & 
					(.count(gatherCommitment(_,_))<.count(item(_,_,_,parts([])))) &
				    not craftCommitment(NAMEAGENT,_)							  &
					not gatherCommitment(NAMEAGENT,_)
	<-
		?gogather(ITEM);
		addGatherCommitment(NAMEAGENT, ITEM);
		!craftSemParts;
	.
	
+!callcraftSemParts	:(role(ROLE,_,_,_,_,_,_,_,_,_,_) & ROLE \== truck )|
		(.count(gatherCommitment(_,_))>=.count(item(_,_,_,parts([]))))
		<-	
		true;
		.

-!callcraftSemParts: true
	<-
		!!callcraftSemParts;
	.	
//@craft[atomic]
+!craftSemParts	:	name(NAMEAGENT)						  & 
					gatherCommitment(NAMEAGENT,ITEM)
				
	<-				
		.wait(resourceNode(_,LATRESOUR,LONRESOUR,ITEM));
		?role(truck,_,_,LOAD,_,_,_,_,_,_,_); 		
		?item(ITEM,TAM,_,_);
		QTD = math.floor( (LOAD / TAM) ) ;		
		?repeat( gather, QTD-2, [], GATHERS );
		.wait(centerStorage(FS));
		.concat([goto(LATRESOUR, LONRESOUR)],GATHERS,[goto(FS),store(ITEM,QTD)],PLAN);
//		+steps( craftSemParts, PLAN);
//		-expectedplan( craftSemParts, _);
//		+expectedplan( craftSemParts, PLAN);
//		+todo(craftSemParts,8);
		!addtask(craftSemParts,8,PLAN,[]);
	.

-task(craftSemParts,8,[_|[]],_): true
//-todo(craftSemParts,8): true
	<-
		!!craftSemParts;
	.	
	