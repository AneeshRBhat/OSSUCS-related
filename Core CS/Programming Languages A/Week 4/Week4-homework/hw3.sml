(* Coursera Programming Languages, Homework 3, Provided Code *)

exception NoAnswer

datatype pattern = Wildcard
		 | Variable of string
		 | UnitP
		 | ConstP of int
		 | TupleP of pattern list
		 | ConstructorP of string * pattern

datatype valu = Const of int
	      | Unit
	      | Tuple of valu list
	      | Constructor of string * valu

fun g f1 f2 p =
    let 
	val r = g f1 f2 
    in
	case p of
	    Wildcard          => f1 ()
	  | Variable x        => f2 x
	  | TupleP ps         => List.foldl (fn (p,i) => (r p) + i) 0 ps
	  | ConstructorP(_,p) => r p
	  | _                 => 0
    end

(**** for the challenge problem only ****)

datatype typ = Anything
	     | UnitT
	     | IntT
	     | TupleT of typ list
	     | Datatype of string;

(**** you can put all your code here ****)

(* Problem 1 *)

(* String list -> String list *)
(* Filter a list of strings to keep only the strings starting with capital letter *)

fun only_capitals ss =
    List.filter (fn s => Char.isUpper (String.sub (s, 0))) ss;

(* Problem 2 *)
(* String list -> String *)
(* Produce the longest string in the list *)

fun longest_string1 ss =
    foldl (fn (s, ls) => if String.size s > String.size ls then s else ls) "" ss;

(* Problem 3 *)
(* String list -> String *)
(* Produce the longest string in the list, in case of a tie the string closer to the end is selected *)

fun longest_string2 ss =
    foldl (fn (s, ls) => if String.size s >= String.size ls then s else ls) "" ss;

(* Problem 4 *)

(* (int * int -> bool) -> string list -> string *)
(* Helper function for longest_string3 and longest_string4 *)

fun longest_string_helper f ss = foldl (fn (s, ls) => if f(String.size s, String.size ls) then s else ls) "" ss;

val longest_string3 = longest_string_helper (fn (cl, ll) => cl > ll);

val longest_string4 = longest_string_helper (fn (cl, ll) => cl >= ll);

(* Problem 5 *)
(* Return the longest string from a list of strings that also begins with a capital list *)

val longest_capitalized = longest_string3 o only_capitals;

(* Problem 6 *)
(* String -> String *)
(* Reverse the order of the characters of a string *)

val rev_string = implode o rev o explode;
							     
(* Problem 7 *)
(* ('a -> 'b option) -> 'a list -> 'b *)
(* Apply f to all elements of lst in order, return v at the first 
   instance of SOME v, raise NoAnswer if all elements return NONE*)

fun first_answer f lst =
    case lst of
	[] => raise NoAnswer
      | x::lst' => case (f x) of NONE => first_answer f lst'
			       | SOME v => v;							  
(* Problem 8 *)
(* ('a -> 'b list option) -> 'a list -> b' list *)
(* Apply f to all element of lst in order, return NONE if any element
   returns NONE, all lst of SOME lst returned by f *)

fun all_answers f xs0 =
    let	fun all_answers_helper (xs, acc) =
	    case xs of
		[] => SOME acc
	      | x::xs' => case (f x) of
			      NONE => NONE
			    | SOME lst => all_answers_helper (xs', lst @ acc)
    in	all_answers_helper (xs0, [])
    end;

(* Problem 9 *)

(* Subquestion 9a *)
(* Pattern -> Int *)
(* Consume a pattern and return how many Wildcard patterns it contains *)
val count_wildcards = g (fn () => 1) (fn s => 0);

			
(* Subquestion 9b *)
(* Pattern -> Int *)
(* Consume a pattern and returns the count of Wildcard patterns plus the length of all Variable strings *)
val count_wild_and_variable_lengths = g (fn () => 1) (fn s => String.size s);

				
(* Subquestion 9c *)
(* String * Pattern -> Int *)
(* Produce the count of how many times s appears in p *)

fun count_some_var (s,p) =
    g (fn () => 0) (fn x => if s = x then 1 else 0) p;

(* Problem 10 *)
(* Pattern -> Boolean *)
(* Produce true iff all variable strings in the pattern are distinct,
   false otherwise *)

fun check_pat p =
    let
	fun collect_vars p =
		case p of
		    Wildcard          => []
		  | Variable x        => [x]
		  | TupleP ps         => List.foldl (fn (p,i) => collect_vars p @ i) [] ps
		  | ConstructorP(_,p) => collect_vars p
		  | _                 => []

	fun check_distinct_strings ss =
	    case ss of
		[] => true
	      | s::ss' => not (List.exists (fn x => s = x) ss') andalso check_distinct_strings ss'
    in
	check_distinct_strings (collect_vars p)
    end;

(* Problem 11 *)
(* (valu * pattern) -> (string * valu) list option *)
(* Return NONE if no patterns match, and SOME lst with 
   lst containing the list of bindings *)

fun match (v, p) =
    case (v, p) of
	(_, Wildcard) => SOME []
      | (v, Variable s) => SOME [(s, v)]
      | (Unit, UnitP) => SOME []
      | (Const i1, ConstP i2) => if i1 = i2
				 then SOME []
				 else NONE
      | (Tuple vs, TupleP ps) => if List.length vs = List.length ps
				 then all_answers match (ListPair.zip(vs, ps))
				 else NONE
      | (Constructor (s1,v), ConstructorP (s2, p)) => if s1 = s2
						      then match(v,p)
						      else NONE
      | _ => NONE;

(* Problem 12 *)
(* valu -> pattern list -> (string * valu) list option *)
(* Return a list option of (s,v) bindings for the first pattern in the list that matches with v *)
fun first_match v lst =
    SOME (first_answer (fn p => match (v, p)) lst)
    handle NoAnswer => NONE;
    

(* ('a -> 'b option) -> 'a list -> 'b *)
(* Apply f to all elements of lst in order, return v at the first   instance of SOME v, raise NoAnswer if all elements return NONE*)

(* Problem 13 - Challenge Problem *)
			   
(* ((string * string * typ) list) * (pattern list) -> typ option *)
