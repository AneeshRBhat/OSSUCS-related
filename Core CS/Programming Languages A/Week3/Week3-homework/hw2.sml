(* Dan Grossman, Coursera PL, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

(* put your solutions for problem 1 here *)

(* Problem 1 *)

(* Subquestion (a) *)

(* String * String list -> String list option *)
(* Produce SOME lst, with s not in the list, if s is present in olst, NONE otherwise *)

fun all_except_option (s, ss) =
    case ss of
	[]     => NONE
      | x::ss' => if same_string (x,s)
		  then SOME ss'
		  else
		      case all_except_option (s,ss') of
			  NONE => NONE
		       |  SOME (i) => SOME(x::i);

(* Subquestion (b) *)
(* String list list * String -> String list *)
(* Produce a list of substitute names for the given s, from the given list of list of strings *)

fun get_substitutions1 (lolos, s) =
    case lolos of
	[] => []
      | ss::lolos' => case all_except_option(s, ss) of
			  NONE => get_substitutions1(lolos', s)
		       |  SOME (i) => i @ get_substitutions1(lolos', s);

(* Subquestion (c) *)
(* String list list * String -> String list *)
(* Tail recursive version of get_substitutions1 *)

fun get_substitutions2 (lolos0, s) = 
    let
	fun get_subs (lolos, rsf) =
	    case lolos of
		[] => rsf
	      | ss::lolos' => case all_except_option(s, ss) of
				  NONE => get_subs(lolos', rsf)
			       |  SOME i => get_subs (lolos', rsf @ i )
    in
	get_subs(lolos0, [])
    end;


(* Subquestion (d) *)
(* string list list * {first:string, last:string, middle:string} -> {first:string, last:string, middle:string} list *)

fun similar_names (lolos, {first=x, last=y, middle=z}) =
    let
	val possible_subs = x::get_substitutions2(lolos, x) 

	fun create_possible_names ns =
	    case ns of
		[] => []
	      | n::ns' => [{first=n, last=y, middle=z}] @ create_possible_names ns'
    in
	create_possible_names (possible_subs)
    end;


	     
(* you may assume that Num is always used with values 2, 3, ..., 10
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove;

(* put your solutions for problem 2 here *)
					   					  
(* Problem 2 *)

(* Subquestion (a) *)

(* Card -> Color *)
(* Produce the color of the given card *)

fun card_color card =
    case card of
	(Clubs, _) => Black
      | (Diamonds, _) => Red
      | (Spades, _) => Black
      | (Hearts, _) => Red;


(* Subquestion (b) *)
(* Card -> Int *)
(* Produce the value of the card, Num -> Int value, Ace -> 11, Others -> 10 *)

fun card_value card =
    case card of
	(_ , Num v) => v
      | (_ , Ace) => 11
      | (_ , King) => 10
      | (_ , Queen) => 10
      | (_, Jack) => 10;

(* Subquestion (c) *)
(* card list * card * exn -> card list *)
(* Produce cs without c in it, if c is present in it. Raise exception otherwise *)

fun remove_card (cs, c, exep) =
    case cs of
	[] => raise exep
      | card::cs' => if card = c
		     then cs'
		     else card::remove_card(cs', c, exep);

(* Subquestion (d) *)
(* card list => Bool *)
(* Produce true if all cards are of the same color, false otherwise *)

fun all_same_color cs =
    case cs of
	[] => true
      | c::[] => true
      | c1::c2::cs' => ((card_color c1) = (card_color c2))
		       andalso
		       all_same_color (c2::cs');

(* Subquestion (e) *)
(* card list -> int *)
(* Produce the sum of the values of all cards in the list *)

fun sum_cards cs0 =
    (* rsf is int; Context preserving accumulator, sum of values of cards visited so far *)
    let
	fun sum_cards (cs, rsf) =
	    case cs of
		[] => rsf
	      | c::cs' => sum_cards (cs', rsf + card_value(c))
    in
	sum_cards(cs0, 0)
    end;

(* Subquestion (f) *)

(* card list * int -> int *)
(* Produce the score of the held cards according to the goal *)

fun score (hcs, goal) =
    let
	val sum = sum_cards hcs
	val preliminary_score = if sum > goal
				then 3*(sum-goal)
				else (goal-sum)
	val final_score = if all_same_color hcs
			  then preliminary_score div 2
			  else preliminary_score
    in
	final_score
     end;
			 
(* subquestion (g) *)

(* card list * move list * int -> int *)
(* Run a game of solitaire, go through some or all of the moves, and return the score at the end *)

fun officiate (cs, ms, goal) =
    let
	fun perform_moves (ms, cs, hcs) =
	    case ms of
		[] => score (hcs, goal)
	      | Discard c::ms' => perform_moves(ms', cs, remove_card(hcs, c, IllegalMove))
	      | Draw::ms' => case cs of
				 [] => score (hcs, goal)
			       | c::cs' =>
				 let
				     val new_hand = c::hcs
				     val sum = sum_cards (new_hand)
				 in
				     if sum > goal
				     then score (new_hand, goal)
				     else perform_moves (ms', cs', new_hand)
				 end;
    in
	perform_moves(ms, cs, [])
    end;

(* Problem 3: Challenge Problem *)

(* Subquestion (a) *)

(* card list * int -> int *)
(* Challenge version of score, Aces can have value of 1 or 11: Whichever leads to the best score *)

fun sum_cards_challenge cs0 =
    (* rsf is int; Context preserving accumulator, sum of values of cards visited so far *)
    (* acc is int; Context preserving accumulator, no. of Aces seen so far in the list *)
    let
	fun sum_cards (cs, rsf) =
	    case cs of
		[] => rsf
	      | (_, Ace)::cs' => sum_cards (cs', rsf)
	      | (s, r)::cs' => sum_cards (cs', rsf + card_value((s,r)))
    in
	sum_cards(cs0, 0)
    end;

fun score_challenge (hcs, goal) = 
    let						
	fun assign_ace_values (cs, sum) =
	    case (cs, sum) of
		([], sum) => sum
	      | ((_, Ace)::cs', sum) => if sum+11 > goal
					then assign_ace_values (cs', sum + 11)
					else assign_ace_values (cs', sum + 1)
	      | (_::cs', sum) => assign_ace_values(cs', sum)
							
	val sum = assign_ace_values (hcs, (sum_cards_challenge hcs))
	val preliminary_score = if sum > goal
				then 3*(sum-goal)
				else (goal-sum)
	val final_score = if all_same_color hcs
			  then preliminary_score div 2
		  	  else preliminary_score
    in
	final_score
    end;

fun officiate_challenge (cs, ms, goal) =
    let
	fun perform_moves (ms, cs, hcs) =
	    case ms of
		[] => score_challenge (hcs, goal)
	      | Discard c::ms' => perform_moves(ms', cs, remove_card(hcs, c, IllegalMove))
	      | Draw::ms' => case cs of
				 [] => score_challenge (hcs, goal)
			       | c::cs' =>
				 let
				     val new_hand = c::hcs
				     val sum = sum_cards_challenge (new_hand)
				 in
				     if sum > goal
				     then score_challenge (new_hand, goal)
				     else perform_moves (ms', cs', new_hand)
				 end;
    in
	perform_moves(ms, cs, [])
    end;

(* Problem 2: Challenge Problems *)

(* card list * int -> move list *)
(* Produce a list of moves that get the value of held cards (initially empty) to the goal, i.e., score 0 *)

fun careful_player (cs0, goal) =
    let
	fun make_move_list (cs, ms, hcs) = 
	    case (cs, ms,  hcs) of
		([], ms, hcs) => if score (hcs, goal) = 0
				 then ms
				 else ms @ [Draw]
	      | (c::cs', ms, hcs) => if score (hcs, goal) = 0
				     then ms
				     else
					 let val card_total = sum_cards hcs
					     val new_total = (card_value c) + card_total
					 in
					     if (card_total + 10) < goal
					     then make_move_list (cs', ms @ [Draw], c::hcs)
					     else
						 if new_total <= goal
						 then make_move_list(cs', ms @ [Draw], c::hcs)
						 else
						     let
							 exception ThisWillNeverHappen
							 val value_over_goal = new_total - goal
							 fun waste_card (hcs, v) =
							     case hcs of
								 [] => raise ThisWillNeverHappen
							       | hc::hcs' => if (card_value hc) >= v
									     then hc
									     else waste_card (hcs', v)

							 val to_remove = waste_card (hcs, value_over_goal)
							 val new_hand = remove_card(hcs, to_remove, IllegalMove)
						     in
							 make_move_list(cs', ms@[Draw, Discard to_remove], c::new_hand)
						     end
					 end
    in
	make_move_list (cs0, [], [])
    end
	







						   
				 


