use "hw2.sml";
(* Homework2 Simple Test *)

(* These are basic test cases. Passing these tests does not guarantee that your code will pass the actual homework grader *)
(* To run the test, add a new line to the top of this file: use "homeworkname.sml"; *)
(* All the tests should evaluate to true. For example, the REPL should say: val test1 = true : bool *)

val card_list0 = [(Hearts, Ace)]
val card_list1 = [(Clubs, Num 9), (Spades, Num 6), (Clubs, Num 7), (Hearts, Num 8)]
val card_list2 = [(Clubs, Num 9), (Spades, Num 6), (Clubs, Num 7), (Diamonds, Num 2), (Hearts, Num 8)]
val card_list3 = [(Spades, King), (Hearts, Num 10), (Hearts, Num 3), (Spades, Num 2), (Spades, Num 8)]
val card_list4 = [(Spades, Num 3), (Diamonds, Num 9), (Clubs, Num 4), (Clubs, Num 6), (Diamonds, Num 6)]
		     

val test1 = all_except_option ("string", ["string"]) = SOME []

val test2 = get_substitutions1 ([["foo"],["there"]], "foo") = []

val test3 = get_substitutions2 ([["foo"],["there"]], "foo") = []
								  
val test4 = similar_names ([["Fred","Fredrick"],
			    ["Elizabeth","Betty"],
			    ["Freddie","Fred","F"]],
			   {first="Fred", middle="W", last="Smith"}) =
	    [{first="Fred", last="Smith", middle="W"},
	     {first="Fredrick", last="Smith", middle="W"},
	     {first="Freddie", last="Smith", middle="W"},
	     {first="F", last="Smith", middle="W"}]

val test5a = card_color (Clubs, Num 2) = Black
val test5b = card_color (Diamonds, King) = Red
val test5c = card_color (Spades, Ace) = Black
					    

val test6a = card_value (Clubs, Num 2) = 2
val test6b = card_value (Hearts, Ace) = 11
val test6c = card_value (Diamonds, King) = 10
val test6d = card_value (Spades, Queen) = 10
val test6e = card_value (Clubs, Jack) = 10
					    
val test7a = remove_card ([(Hearts, Ace)], (Hearts, Ace), IllegalMove) = [];

val test7b = remove_card ([(Spades, Num 2),
			   (Diamonds, King)],
			  (Diamonds, King), IllegalMove)
	     = [(Spades, Num 2)];					
val test7c = remove_card ([(Spades, Num 2),
			   (Diamonds, King)],
			  (Spades, Num 2), IllegalMove)
	     = [(Diamonds, King)];

val test7d = (remove_card ([(Spades, Num 2),
			    (Diamonds, King)],
			   (Spades, Num 3), IllegalMove)
	      handle IllegalMove => [(Spades, Num 2),
				     (Diamonds, King)])
	     = [(Spades, Num 2),
		(Diamonds, King)]
		   
	     

val test8a = all_same_color [(Hearts, Ace), (Hearts, Ace)] = true
val test8b = all_same_color [(Hearts, Ace), (Diamonds, Num 2)] = true
val test8c = all_same_color [(Hearts, Ace), (Spades, Ace)] = false
								
val test9a = sum_cards [(Clubs, Num 2),(Clubs, Num 2)] = 4;
val test9b = sum_cards [(Clubs, Num 2), (Hearts, Ace), (Diamonds, King)] = 2 + 11 + 10;
val test9b = sum_cards [(Spades, Num 10), (Clubs, Queen), (Diamonds, Jack)] = 10 + 10 + 10;


val test10a = score ([(Hearts, Num 2),(Clubs, Num 4)],10) = 4
val test10b = score ([(Hearts, Num 2),(Diamonds, Num 4)],10)
	      = (10 - (4+2)) div 2
val test10c = score ([(Hearts, Ace)], 10) = (3*(11-10)) div 2
val test10d = score ([(Hearts, Ace),(Spades, King)],20)
	      = 3*((10+11)-20)

val test11 = officiate ([(Hearts, Num 2),(Clubs, Num 4)],[Draw], 15) = 6

val test12 = officiate ([(Clubs,Ace),(Spades,Ace),(Clubs,Ace),(Spades,Ace)],
                        [Draw,Draw,Draw,Draw,Draw],
                        42)
             = 3

val test13 = ((officiate([(Clubs,Jack),(Spades,Num(8))],
                         [Draw,Discard(Hearts,Jack)],
                         42); false)
	      handle IllegalMove => true)


val test14a = score_challenge ([(Hearts, Num 2),(Clubs, Num 4)],10) = 4
									  
val test14b = score_challenge ([(Hearts, Num 2),(Diamonds, Num 4)],10)
	      = (10 - (4+2)) div 2
				     
val test14c = score_challenge ([(Hearts, Ace)], 10) = (3*(11-10)) div 2
									  
val test14d = score_challenge ([(Hearts, Ace),(Spades, King)],20)
	      = 3*((10+11)-20)

val test14e = score_challenge ([(Hearts, Ace),(Spades, King)], 15)
	      = 3*(21-15)



		     
val test15a = careful_player (card_list0, 11) = [Draw]
val test15b = careful_player (card_list1, 30) = [Draw, Draw, Draw, Draw]
val test15c = careful_player (card_list2, 30) = [Draw, Draw, Draw, Draw, Draw, Discard (Diamonds, Num 2)]
val test15d = careful_player (card_list3, 30) = [Draw, Draw, Draw, Draw, Draw, Discard (Hearts, Num 3)]
val test15e = careful_player (card_list4, 30) = [Draw, Draw, Draw, Draw, Draw, Draw]
