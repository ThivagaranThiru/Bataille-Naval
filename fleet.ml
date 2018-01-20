type fleet = 
	|Fleet of (int * int) list;;

let empty = Fleet([]);;

let is_empty l = 
	match l with
	|Fleet([]) -> true
	|_-> false;;

let rec add_ship l x = 
	match l with 
	|Fleet([]) -> Fleet([(x,1)])
	|Fleet((a,b) :: t) -> if a = x 
							then Fleet((a,b+1) :: t)
						  else Fleet((a,b) :: match add_ship (Fleet(t)) x with Fleet(p')-> p') ;;

let rec remove_ship l x = 
	match l with 
	|Fleet([]) -> Fleet([(x,0)])
	|Fleet((a,b) :: t) -> if a = x 
							then Fleet((a,b-1) :: t)
						  else Fleet((a,b) :: match remove_ship (Fleet(t)) x with Fleet(p')-> p') ;;

let rec get_quantity l x = 
	match l with 
	|Fleet([]) -> 0
	|Fleet((a,b) :: t) -> if a = x 
							then b 
						  else get_quantity (Fleet(t)) x;;
let rec max_size l = 
	match l with
	|Fleet([]) -> 0 
	|Fleet((a,b) :: []) -> a 
	|Fleet((c,d)::(e,f) :: t) -> if c > e 
	                              	then max_size (Fleet((c,d)::t))
	                             else max_size (Fleet((e,f)::t));;
let rec fleet_exist l x = 
	match l with 
	|Fleet([]) -> false
	|Fleet((a,b) :: t) -> if a = x && b > 0 then true else fleet_exist (Fleet(t)) x;;	

let f = Fleet((1,3) :: (2,5) :: (3,4) :: (4,2) :: (5,1) :: []);; (*La liste Flotte à placée sur la grille*)


type orientation = Gauche | Droite | Haut | Bas;;

let n = ([]);; 

let debordement n taille = 
	match n with
	|(s,x,y,Haut) -> if x < 0 || x > taille || (y + (s*40)) > taille || y < 0 then false else true 
	|(s,x,y,Bas) -> if (y - (s*40)) < 0 || x > taille || x < 0 || y > taille then false else true  
	|(s,x,y,Gauche) -> if (x - (s*40)) < 0 || y > taille || y < 0 || x > taille then false else true 
	|(s,x,y,Droite) ->if ((s*40) + x) > taille || y > taille  || y < 0  || x < 0 then false else true;;

let contact_actuelle_Haut a b = 
	let (s,x,y,orientation) = a in 
	let (s1,x1,y1,orientation) = b in
	let rec loop c d i j = 
		if i > (s+1) 
			then if j < (s1+1)
					then (loop (a) ((s1,x1,(y1+j+40),orientation)) (0) ((j+1)))
				 else true
		else (match (c,d) with
			  |((e,f,g,Haut),(h,k,l,Haut)) -> if (f=k) && ((g-40)=l)	
											 	then false
											else (loop ((e,f,(g+40),Haut)) ((h,k,l,Haut)) (i+1) (j))
			  |((e,f,g,Bas),(h,k,l,Haut)) -> if (f=k) && ((g+40)=l)	
											 	then false
											else (loop ((e,f,(g-40),Bas)) ((h,k,l,Haut)) (i+1) (j))
			  |((e,f,g,Droite),(h,k,l,Haut)) -> if ((f-40)=k) && (g=l)	
											 	then false
											else (loop ((e,(f+40),g,Droite)) ((h,k,l,Haut)) (i+1) (j))
			  |((e,f,g,Gauche),(h,k,l,Haut)) -> if ((f+40)=k) && (g=l)	
											 	then false
											else (loop ((e,(f-40),g,Gauche)) ((h,k,l,Haut)) (i+1) (j))
			 |((_,_,_,_),(_,_,_,_)) -> failwith "erreur")
	in loop a b 0 0;;

let contact_actuelle_Bas a b = 
	let (s,x,y,orientation) = a in 
	let (s1,x1,y1,orientation) = b in
	let rec loop c d i j = 
		if i > (s+1) 
			then if j < (s1+1) 
					then (loop (a) ((s1,x1,(y1-j-40),orientation)) (0) ((j+1)))
				 else true
		else (match (c,d) with
			  |((e,f,g,Haut),(h,k,l,Bas)) -> if (f=k) && ((g-40)=l)	
											 	then false
											else (loop ((e,f,(g+40),Haut)) ((h,k,l,Bas)) (i+1) (j))
			  |((e,f,g,Bas),(h,k,l,Bas)) -> if (f=k) && ((g+40)=l)	
											 	then false
											else (loop ((e,f,(g-40),Bas)) ((h,k,l,Bas)) (i+1) (j))
			  |((e,f,g,Droite),(h,k,l,Bas)) -> if ((f-40)=k ) && (g=l)	
											 	then false
											else (loop ((e,(f+40),g,Droite)) ((h,k,l,Bas)) (i+1) (j))
			  |((e,f,g,Gauche),(h,k,l,Bas)) -> if ((f+40)=k) && (g=l)	
											 	then false
											else (loop ((e,(f-40),g,Gauche)) ((h,k,l,Bas)) (i+1) (j))
			  |((_,_,_,_),(_,_,_,_)) ->  contact_actuelle_Haut a b) 
	in loop a b 0 0;;

let contact_actuelle_Gauche a b = 
	let (s,x,y,orientation) = a in 
	let (s1,x1,y1,orientation) = b in
	let rec loop c d i j = 
		if i > (s+1) 
			then if j < (s1+1)
					then (loop (a) ((s1,(x1-j-40),y1,orientation)) (0) ((j+1)))
				 else true
		else (match (c,d) with
			  |((e,f,g,Haut),(h,k,l,Gauche)) -> if (f=k) && ((g-40)=l)	
											 	then false
											else (loop ((e,f,(g+40),Haut)) ((h,k,l,Gauche)) (i+1) (j))
			  |((e,f,g,Bas),(h,k,l,Gauche)) -> if (f=k) && ((g+40)=l)	
											 	then false
											else (loop ((e,f,(g-40),Bas)) ((h,k,l,Gauche)) (i+1) (j))
			  |((e,f,g,Droite),(h,k,l,Gauche)) -> if ((f-40)=k) && (g=l)	
											 	then false
											else (loop ((e,(f+40),g,Droite)) ((h,k,l,Gauche)) (i+1) (j))
			  |((e,f,g,Gauche),(h,k,l,Gauche)) -> if ((f+40)=k) && (g=l)	
											 	then false
											else (loop ((e,(f-40),g,Gauche)) ((h,k,l,Gauche)) (i+1) (j))
			  |((_,_,_,_),(_,_,_,_)) ->  contact_actuelle_Bas a b) 
	in loop a b 0 0;;

let contact_actuelle_Droite a b = 
	let (s,x,y,orientation) = a in 
	let (s1,x1,y1,orientation) = b in
	let rec loop c d i j = 
		if i > (s+1) 
			then if j < (s1+1) 
					then (loop (a) ((s1,(x1+j+40),y1,orientation)) (0) ((j+1)))
				 else true
		else (match (c,d) with
			  |((e,f,g,Haut),(h,k,l,Droite)) -> if (f=k) && ((g-40)=l)	
											 	then false
											else (loop ((e,f,(g+40),Haut)) ((h,k,l,Droite)) (i+1) (j))
			  |((e,f,g,Bas),(h,k,l,Droite)) -> if (f=k) && ((g+40)=l)	
											 	then false
											else (loop ((e,f,(g-40),Bas)) ((h,k,l,Droite)) (i+1) (j))
			  |((e,f,g,Droite),(h,k,l,Droite)) -> if ((f-40)=k) && (g=l)	
											 	then false
											else (loop ((e,(f+40),g,Droite)) ((h,k,l,Droite)) (i+1) (j))
			  |((e,f,g,Gauche),(h,k,l,Droite)) -> if ((f+40)=k) && (g=l)	
											 	then false
											else (loop ((e,(f-40),g,Gauche)) ((h,k,l,Droite)) (i+1) (j))
			  |((_,_,_,_),(_,_,_,_)) ->  contact_actuelle_Gauche a b) 
	in loop a b 0 0;;

let contact_Haut_Gauche a b = 
	let (s,x,y,orientation) = a in 
	let (s1,x1,y1,orientation) = b in
	let rec loop c d i j = 
		if i > (s+1) 
			then if j < (s1+1) 
					then (loop (a) ((s1,x1,(y1+j+40),orientation)) (0) ((j+1)))
				 else true
		else (match (c,d) with
			  |((e,f,g,Haut),(h,k,l,Haut)) -> if ((f-40)=k) && ((g-40)=l)	
											 	then false
											else (loop ((e,f,(g+40),Haut)) ((h,k,l,Haut)) (i+1) (j))
			  |((e,f,g,Bas),(h,k,l,Haut)) -> if ((f-40)=k) && ((g+40)=l)	
											 	then false
											else (loop ((e,f,(g-40),Bas)) ((h,k,l,Haut)) (i+1) (j))
			  |((e,f,g,Droite),(h,k,l,Haut)) -> if ((f-40)=k) && ((g-40)=l)	
											 	then false
											else (loop ((e,(f+40),g,Droite)) ((h,k,l,Haut)) (i+1) (j))
			  |((e,f,g,Gauche),(h,k,l,Haut)) -> if ((f+40)=k) && ((g-40)=l)	
											 	then false
											else (loop ((e,(f-40),g,Gauche)) ((h,k,l,Haut)) (i+1) (j))
			 |((_,_,_,_),(_,_,_,_)) ->  failwith "erreur")
	in loop a b 0 0;;

let contact_Bas_Gauche a b = 
	let (s,x,y,orientation) = a in 
	let (s1,x1,y1,orientation) = b in
	let rec loop c d i j = 
		if i > (s+1) 
			then if j < (s1+1)
					then (loop (a) ((s1,x1,(y1-j-40),orientation)) (0) ((j+1)))
				 else true
		else (match (c,d) with
			  |((e,f,g,Haut),(h,k,l,Bas)) -> if ((f-40)=k) && ((g-40)=l)	
											 	then false
											else (loop ((e,f,(g+40),Haut)) ((h,k,l,Bas)) (i+1) (j))
			  |((e,f,g,Bas),(h,k,l,Bas)) -> if ((f-40)=k) && ((g+40)=l)	
											 	then false
											else (loop ((e,f,(g-40),Bas)) ((h,k,l,Bas)) (i+1) (j))
			  |((e,f,g,Droite),(h,k,l,Bas)) -> if ((f-40)=k) && ((g-40)=l)	
											 	then false
											else (loop ((e,(f+40),g,Droite)) ((h,k,l,Bas)) (i+1) (j))
			  |((e,f,g,Gauche),(h,k,l,Bas)) -> if ((f+40)=k) && ((g-40)=l)	
											 	then false
											else (loop ((e,(f-40),g,Gauche)) ((h,k,l,Bas)) (i+1) (j))
			  |((_,_,_,_),(_,_,_,_)) ->  contact_Haut_Gauche a b) 
	in loop a b 0 0;;

let contact_Gauche_Gauche a b = 
	let (s,x,y,orientation) = a in 
	let (s1,x1,y1,orientation) = b in
	let rec loop c d i j = 
		if i > (s+1) 
			then if j < (s1+1)
					then (loop (a) ((s1,(x1-j-40),y1,orientation)) (0) ((j+1)))
				 else true
		else (match (c,d) with
			  |((e,f,g,Haut),(h,k,l,Gauche)) -> if ((f-40)=k) && ((g-40)=l)	
											 	then false
											else (loop ((e,f,(g+40),Haut)) ((h,k,l,Gauche)) (i+1) (j))
			  |((e,f,g,Bas),(h,k,l,Gauche)) -> if ((f-40)=k) && ((g+40)=l)	
											 	then false
											else (loop ((e,f,(g-40),Bas)) ((h,k,l,Gauche)) (i+1) (j))
			  |((e,f,g,Droite),(h,k,l,Gauche)) -> if ((f-40)=k) && ((g-40)=l)	
											 	then false
											else (loop ((e,(f+40),g,Droite)) ((h,k,l,Gauche)) (i+1) (j))
			  |((e,f,g,Gauche),(h,k,l,Gauche)) -> if ((f+40)=k) && ((g-40)=l)	
											 	then false
											else (loop ((e,(f-40),g,Gauche)) ((h,k,l,Gauche)) (i+1) (j))
			  |((_,_,_,_),(_,_,_,_)) ->  contact_Bas_Gauche a b) 
	in loop a b 0 0;;

let contact_Droite_Gauche a b = 
	let (s,x,y,orientation) = a in 
	let (s1,x1,y1,orientation) = b in
	let rec loop c d i j = 
		if i > (s+1)
			then if j < (s1+1) 
					then (loop (a) ((s1,(x1+j+40),y1,orientation)) (0) ((j+1)))
				 else true
		else (match (c,d) with
			  |((e,f,g,Haut),(h,k,l,Droite)) -> if ((f-40)=k) && ((g-40)=l)	
											 	then false
											else (loop ((e,f,(g+40),Haut)) ((h,k,l,Droite)) (i+1) (j))
			  |((e,f,g,Bas),(h,k,l,Droite)) -> if ((f-40)=k) && ((g+40)=l)	
											 	then false
											else (loop ((e,f,(g-40),Bas)) ((h,k,l,Droite)) (i+1) (j))
			  |((e,f,g,Droite),(h,k,l,Droite)) -> if ((f-40)=k) && ((g-40)=l)	
											 	then false
											else (loop ((e,(f+40),g,Droite)) ((h,k,l,Droite)) (i+1) (j))
			  |((e,f,g,Gauche),(h,k,l,Droite)) -> if ((f+40)=k) && ((g-40)=l)	
											 	then false
											else (loop ((e,(f-40),g,Gauche)) ((h,k,l,Droite)) (i+1) (j))
			  |((_,_,_,_),(_,_,_,_)) ->  contact_Gauche_Gauche a b) 
	in loop a b 0 0;;

let contact_Haut_Droit a b = 
	let (s,x,y,orientation) = a in 
	let (s1,x1,y1,orientation) = b in
	let rec loop c d i j = 
		if i > (s+1)
			then if j < (s1+1) 
					then (loop (a) ((s1,x1,(y1+j+40),orientation)) (0) ((j+1)))
				 else true
		else (match (c,d) with
			  |((e,f,g,Haut),(h,k,l,Haut)) -> if ((f+40)=k)&& ((g-40)=l)	
											 	then false
											else (loop ((x,f,(g+40),Haut)) ((h,k,l,Haut)) (i+1) (j))
			  |((e,f,g,Bas),(h,k,l,Haut)) -> if ((f+40)=k) && ((g+40)=l)	
											 	then false
											else (loop ((e,x,(g-40),Bas)) ((h,k,l,Haut)) (i+1) (j))
			  |((e,f,g,Droite),(h,k,l,Haut)) -> if ((f-40)=k) && ((g+40)=l)	
											 	then false
											else (loop ((e,(f+40),g,Droite)) ((h,k,l,Haut)) (i+1) (j))
			  |((e,f,g,Gauche),(h,k,l,Haut)) -> if ((f+40)=k) && ((g+40)=l)	
											 	then false
											else (loop ((e,(f-40),g,Gauche)) ((h,k,l,Haut)) (i+1) (j))
			 |((_,_,_,_),(_,_,_,_)) ->  failwith "erreur")
	in loop a b 0 0;;

let contact_Bas_Droit a b = 
	let (s,x,y,orientation) = a in 
	let (s1,x1,y1,orientation) = b in
	let rec loop c d i j = 
		if i >(s+1)
			then if j < (s1+1) 
					then (loop (a) ((s1,x1,(y1-j-40),orientation)) (0) ((j+1)))
				 else true
		else (match (c,d) with
			  |((e,f,g,Haut),(h,k,l,Bas)) -> if ((f+40)=k) && ((g-40)=l)	
											 	then false
											else (loop ((e,f,(g+40),Haut)) ((h,k,l,Bas)) (i+1) (j))
			  |((e,f,g,Bas),(h,k,l,Bas)) -> if ((f+40)=k) && ((g+40)=l)	
											 	then false
											else (loop ((e,f,(g-40),Bas)) ((h,k,l,Bas)) (i+1) (j))
			  |((e,f,g,Droite),(h,k,l,Bas)) -> if ((f-40)=k) && ((g+40)=l)	
											 	then false
											else (loop ((e,(f+40),g,Droite)) ((h,k,l,Bas)) (i+1) (j))
			  |((e,f,g,Gauche),(h,k,l,Bas)) -> if ((f+40)=k) && ((g+40)=l)	
											 	then false
											else (loop ((e,(f-40),g,Gauche)) ((h,k,l,Bas)) (i+1) (j))
			  |((_,_,_,_),(_,_,_,_)) ->  contact_Haut_Droit a b) 
	in loop a b 0 0;;

let contact_Gauche_Droit a b = 
	let (s,x,y,orientation) = a in 
	let (s1,x1,y1,orientation) = b in
	let rec loop c d i j = 
		if i >(s+1)
			then if j < (s1+1) 
					then (loop (a) ((s1,(x1-j-40),y1,orientation)) (0) ((j+1)))
				 else true
		else (match (c,d) with
			  |((e,f,g,Haut),(h,k,l,Gauche)) -> if ((f+40)=k) && ((g-40)=l)	
											 	then false
											else (loop ((e,f,(g+40),Haut)) ((h,k,l,Gauche)) (i+1) (j))
			  |((e,f,g,Bas),(h,k,l,Gauche)) -> if ((f+40)=k) && ((g+40)=l)	
											 	then false
											else (loop ((e,f,(g-40),Bas)) ((h,k,l,Gauche)) (i+1) (j))
			  |((e,f,g,Droite),(h,k,l,Gauche)) -> if ((f-40)=k) && ((g+40)=l)	
											 	then false
											else (loop ((e,(f+40),g,Droite)) ((h,k,l,Gauche)) (i+1) (j))
			  |((e,f,g,Gauche),(h,k,l,Gauche)) -> if ((f+40)=k) && ((g+40)=l)	
											 	then false
											else (loop ((e,(f-40),g,Gauche)) ((h,k,l,Gauche)) (i+1) (j))
			  |((_,_,_,_),(_,_,_,_)) ->  contact_Bas_Droit a b) 
	in loop a b 0 0;;

let contact_Droite_Droit a b = 
	let (s,x,y,orientation) = a in 
	let (s1,x1,y1,orientation) = b in
	let rec loop c d i j = 
		if i > (s+1) 
			then if j < (s1+1) 
					then (loop (a) ((s1,(x1+j+40),y1,orientation)) (0) ((j+1)))
				 else true
		else (match (c,d) with
			  |((e,f,g,Haut),(h,k,l,Droite)) -> if ((f+40)=k) && ((g-40)=l)	
											 	then false
											else (loop ((e,f,(g+40),Haut)) ((h,k,l,Droite)) (i+1) (j))
			  |((e,f,g,Bas),(h,k,l,Droite)) -> if ((f+40)=k) && ((g+40)=l)	
											 	then false
											else (loop ((e,f,(g-40),Bas)) ((h,k,l,Droite)) (i+1) (j))
			  |((e,f,g,Droite),(h,k,l,Droite)) -> if ((f-40)=k) && ((g+40)=l)	
											 	then false
											else (loop ((e,(f+40),g,Droite)) ((h,k,l,Droite)) (i+1) (j))
			  |((e,f,g,Gauche),(h,k,l,Droite)) -> if ((f+40)=k) && ((g+40)=l)	
											 	then false
											else (loop ((e,(f-40),g,Gauche)) ((h,k,l,Droite)) (i+1) (j))
			  |((_,_,_,_),(_,_,_,_)) ->  contact_Gauche_Droit a b) 
	in loop a b 0 0;;

let rec contact_list l e =  
	match l with 
	|[] -> true
	|r :: t -> if (debordement e 400) = true 
							then if (contact_actuelle_Droite e r ) = true
					 				then if (contact_Droite_Gauche e r) = true
					 						then if (contact_Droite_Droit e r) = true
					 								then contact_list t e
					 							else false
					 					else false
					 			else false
			 			else false;;

let rec touch l x y = 
	match l with 
	|[] -> false
	|((s,a,b,Haut):: t) -> (let rec loop c d i = 
								if i < s  
									then if (c=x) && (d=y)
											then true
										else (loop c (d+40) (i+1))
								else (touch t x y)
							in loop (600+a) b 0)
	|((s,a,b,Bas):: t) -> (let rec loop c d i = 
								if i < s  
									then if (c=x) && (d=y)
											then true
										else (loop c (d-40) (i+1))
								else (touch t x y)
							in loop (600+a) b 0)
	|((s,a,b,Droite):: t) -> (let rec loop c d i = 
								if i < s  
									then if (c=x) && (d=y)
											then true
										else (loop (c+40) d (i+1))
								else (touch t x y)
							in loop (600+a) b 0)
	|((s,a,b,Gauche):: t) -> (let rec loop c d i = 
								if i < s  
									then if (c=x) && (d=y)
											then true
										else (loop (c-40) d (i+1))
								else (touch t x y)
							in loop (600+a) b 0);;


let (@@) f x = f x

let drawRectangle a b c d = Interaction.fillRectangle a b c d 
let drawLine a b c d = Interaction.drawLines ((a,b,c,d)::[])

let program =
	Interaction.openWindow "" @@ fun () ->
	Interaction.resizeWindow 2000 2000 @@ fun () ->
	Interaction.setWindowTitle "La Bataille Navale" @@ fun () ->
	let rec loop s a b x y =
		Interaction.setColor Interaction.blue @@ fun () -> 
		Interaction.drawLines ((40,400,40,0)::(80,400,80,0)::(120,400,120,0)::(160,400,160,0)::(200,400,200,0)::(240,400,240,0)::(280,400,280,0)::(320,400,320,0)::(360,400,360,0)::(400,400,400,0)::[]) @@ fun () ->
	    Interaction.drawLines ((0,40,400,40)::(0,80,400,80)::(0,120,400,120)::(0,160,400,160)::(0,200,400,200)::(0,240,400,240)::(0,280,400,280)::(0,320,400,320)::(0,360,400,360)::(0,400,400,400)::[]) @@ fun () ->
	    
	    Interaction.drawLines ((600,400,600,0)::(640,400,640,0)::(680,400,680,0)::(720,400,720,0)::(760,400,760,0)::(800,400,800,0)::(840,400,840,0)::(880,400,880,0)::(920,400,920,0)::(960,400,960,0)::(1000,400,1000,0)::[]) @@ fun () ->
	    Interaction.drawLines ((600,40,1000,40)::(600,80,1000,80)::(600,120,1000,120)::(600,160,1000,160)::(600,200,1000,200)::(600,240,1000,240)::(600,280,1000,280)::(600,320,1000,320)::(600,360,1000,360)::(600,400,1000,400)::[]) @@ fun () ->
		Interaction.waitNextEvent (Interaction.ButtonDown::Interaction.KeyPressed::[]) 
		@@ fun cx cy bp kp k -> 

		if bp = true && cx >= 600 && cx < 1000 && cy >= 0 && cy < 400
			then (match touch b ((cx/40)*40) ((cy/40)*40) with 
					|false -> Interaction.setColor Interaction.green @@ fun () ->  
						 	 drawRectangle (((cx/40)*40)) (((cy/40)*40)) 40 40 @@ fun () -> loop s a b cx cy
					|true  ->Interaction.setColor Interaction.magenta @@ fun () ->
                  			 drawLine ((cx/40)*40) (((cy/40)*40)+40) (((cx/40)*40)+40) (((cy/40)*40)) @@ fun () ->
                  			 drawLine (((cx/40)*40)+40) (((cy/40)*40)+40) ((cx/40)*40) ((cy/40)*40) @@ fun () -> loop s a b cx cy)
		else if kp && k = '1' 
		    then loop 1 a b cx cy
		else if kp && k = '2' 
		    then loop 2 a b cx cy
		else if kp && k = '3' 
		    then loop 3 a b cx cy 
		else if kp && k = '4' 
		   	then loop 4 a b cx cy 
		else if kp && k = '5' 
		    then loop 5 a b cx cy
		else if kp && k = 'g' then match fleet_exist a s with
			        		|false -> Interaction.drawString 40 560 ("Desole ce navie n'exite plus" ) @@ fun () -> loop s a b cx cy
							|true -> (match contact_list b (s,((cx/40)*40),((cy/40)*40),Gauche) with 
									   |false -> Interaction.drawString 40 520 ("Vous ne pouvez pas le placez" ) @@ fun () -> loop s a b cx cy 
			        	 			   |true ->  Interaction.setColor Interaction.cyan @@ fun () ->  
						 						 drawRectangle (((cx/40)*40)-(40*(s-1))) (((cy/40)*40)) (40*s) 40 @@ fun () -> loop s (remove_ship a s) ((s,((cx/40)*40),((cy/40)*40),Gauche)::b) cx cy )
		else if kp && k = 'd' 
		        then (match fleet_exist a s with
		        		|false -> Interaction.drawString 160 560 ("Desole ce navie n'exite plus" ) @@ fun () -> loop s a b cx cy
						|true -> (match contact_list b (s,((cx/40)*40),((cy/40)*40),Droite) with 
								   |false -> Interaction.drawString 40 520 ("Vous ne pouvez pas le placez" ) @@ fun () -> loop s a b cx cy 
		        	 			   |true ->  Interaction.setColor Interaction.cyan @@ fun () ->  
					 						 drawRectangle (((cx/40)*40)) (((cy/40)*40)) (40*s) 40 @@ fun () -> loop s (remove_ship a s) ((s,((cx/40)*40),((cy/40)*40),Droite)::b) cx cy ))
		else if kp && k = 'h' 
		        then (match fleet_exist a s with
		        		|false -> Interaction.drawString 40 560 ("Desole ce navie n'exite plus" ) @@ fun () -> loop s a b cx cy
						|true -> (match contact_list b (s,((cx/40)*40),((cy/40)*40),Haut) with 
								   |false -> Interaction.drawString 40 520 ("Vous ne pouvez pas le placez" ) @@ fun () -> loop s a b cx cy 
		        	 			   |true ->  Interaction.setColor Interaction.cyan @@ fun () ->  
					 						 drawRectangle (((cx/40)*40)) (((cy/40)*40)) 40 (40*s) @@ fun () -> loop s (remove_ship a s) ((s,((cx/40)*40),((cy/40)*40),Haut)::b) cx cy ))
		else if kp && k = 'b' 
		        then (match fleet_exist a s with
		        		|false -> Interaction.drawString 40 560 ("Desole ce navie n'exite plus" ) @@ fun () -> loop s a b cx cy
						|true -> (match contact_list b (s,((cx/40)*40),((cy/40)*40),Bas) with 
								   |false -> Interaction.drawString 40 520 ("Vous ne pouvez pas le placez" ) @@ fun () -> loop s a b cx cy 
		        	 			   |true ->  Interaction.setColor Interaction.cyan @@ fun () ->  
					 						 drawRectangle (((cx/40)*40)) (((cy/40)*40)-(40*(s-1))) 40 (40*s) @@ fun () -> loop s (remove_ship a s) ((s,((cx/40)*40),((cy/40)*40),Bas)::b) cx cy ))
		else if kp && k = 'q'
				then Interaction.quit
			else loop s a b cx cy
	in loop 0 f n 0 0

let _ = Interaction.execute program