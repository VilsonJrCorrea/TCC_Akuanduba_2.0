{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("exploration.asl") }
{ include("gathering.asl") }
{ include("fastgathering.asl") }
//{ include("fastgatheringDoCrafting4.asl") }
//{ include("crafting4.asl") }
//{ include("crafting1.asl") }
//{ include("crafting2.asl") }
//{ include("crafting3.asl") }
{ include("crafting5.asl") }
//{ include("crafting6.asl") }
{ include("charging.asl") }		
{ include("regras.asl") }
{ include("job.asl") }
//{ include("job2.asl")}
//{ include("job3.asl") }
{ include("mission.asl") }
//{ include("mission2.asl") }
{ include("construcao_pocos.asl")}
{ include("restartround.asl")}
{ include("huntwell.asl") }
{ include("dropall.asl") }
{ include("areacritica.asl") }
{ include("exceptions.asl") }
@x1[atomic]
+!consumestep: 
				lastActionResult( successful )			& 
				lastDoing(LD)								& 
				task(LD,P,[ACT|T],EXECUTEDPLAN)			&
				lastAction(RLA)							&
				route(ROUTE)							&
				RLA\==noAction							&
				(((RLA=continue | RLA=goto) & ROUTE==[]) |
				  (RLA\==continue & RLA\==goto))
				  						
	<-	
			!removetask(LD,P,[ACT|T],EXECUTEDPLAN);
			if (not T=[]) {
				!addtask(LD,P,T,[ACT|EXECUTEDPLAN])	
			}
	.

@x2[atomic]
+!consumestep: 				
				lastActionResult( successful )			& 
				doing(LD)								& 
				not task(LD,_,_,_)			

	<-true.//.print("acabou ===> ", LD).

@x3[atomic]
+!consumestep: true
	<-true.
	

@x4[atomic]
+!whattodo
	:	.count(task(TD,_,_,_), 0)
	<-	
		-doing(_);
	.
@x5[atomic]	
+!whattodo
	:	.count(task(TD,_,_,_), QTD) &
			QTD > 0
	<-			
		
		?priotodo(TASK);
		-+doing(TASK);
		!checkRollback;
	.

@x6[atomic]
+!checkRollback:not route([]) 				&
				lastDoing(LD) 				& 
				doing(D) 					& 
				LD\==D 						& 
				task(LD,P,PLAN,EXECUTEDPLAN)&
				LD=exploration	
	<-
			?lat(LAT);
			?lon(LON);
			
			!updatetask(LD,P,[goto(LAT,LON)|PLAN],EXECUTEDPLAN);	
	.
@x7[atomic]
+!checkRollback:lastDoing(LD) 				& 
				doing(D) 					& 
				LD\==D 						& 
				task(LD,P,PLAN,EXECUTEDPLAN)&
				LD\==exploration			&
				PLAN=[HL|_]					&
				not (HL=goto(_) |HL=goto(_,_)) 	
	<-
			?rollbackrule([goto(_),goto(_,_)], EXECUTEDPLAN, RACTION);			
			!updatetask(LD,P,[RACTION|PLAN],EXECUTEDPLAN);
	.
@x8[atomic]
+!checkRollback :true
	<- true .

@s1[atomic]
+!do: route(R) &lastDoing(X) & doing(X) & not R=[]
	<-	
		action(continue);
.

@docrafthelp[atomic]
+!do: 
	doing(craftComParts) & 
	 task(craftComParts,P,[help(OTHERROLES)|T],EXECUTEDPLAN) 			
	<-
		.length(OTHERROLES,BARRIER);
		!!supportCraft(OTHERROLES);
		!updatetask(craftComParts,P,T,EXECUTEDPLAN);
		action(noAction);
	.


@dogenerico[atomic]
+!do: 	
		doing(DOING) 	& 
		task(DOING,_,[ACT|T],_)
	<-		
		-+lastDoing(DOING);
		action( ACT );
	.
	
@donothing[atomic]
+!do: true
	<-
		action( noAction );
	.
	

@step[atomic]	
+step( S ): true
	<-
		!testDismantle;
		!testDismantleWellOfEnemy;
		!testarTrabalho;
		!testarMission;
		!consumestep;
		!whattodo;
		!do;
	.	