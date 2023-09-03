(* Homework3 Simple Test*)
use "hw3.sml";
(* These are basic test cases. Passing these tests does not guarantee that your code will pass the actual homework grader *)
(* To run the test, add a new line to the top of this file: use "homeworkname.sml"; *)
(* All the tests should evaluate to true. For example, the REPL should say: val test1 = true : bool *)

val test1 = only_capitals ["A","B","C"] = ["A","B","C"]

val test2 = longest_string1 ["A","bc","C"] = "bc"

val test3 = longest_string2 ["A","bc","C"] = "bc"
val test3b = longest_string2 ["Aneesh", "Pseudopodia", "bin", "Cavema", "FeeFieFoFum"] = "FeeFieFoFum";

val test4a = longest_string3 ["A","bc","C"] = "bc"

val test4b = longest_string4 ["A","B","C"] = "C";


val test5 = longest_capitalized ["A","bc","C"] = "A"

val test6 = rev_string "abc" = "cba"

val test7 = first_answer (fn x => if x > 3 then SOME x else NONE) [1,2,3,4,5] = 4

val test8 = all_answers (fn x => if x = 1 then SOME [x] else NONE) [2,3,4,5,6,7] = NONE

val test9a = count_wildcards Wildcard = 1
val test9a1 = count_wildcards (ConstructorP ("SOMETHING", TupleP [Wildcard, Wildcard, Variable "foo", UnitP, ConstP 15, Wildcard])) = 3
																	
val test9b = count_wild_and_variable_lengths (Variable("a")) = 1
val test9b1 = count_wild_and_variable_lengths (ConstructorP ("SOMETHING", TupleP [Wildcard, Wildcard, Variable "foo", UnitP, ConstP 15, Wildcard])) = 6

val test9c = count_some_var ("x", Variable("x")) = 1
val test9c1 = count_some_var ("foo", TupleP [Wildcard, ConstP 13, Variable "foo", Variable "foo", Wildcard]) = 2;

val test10 = check_pat (Variable("x")) = true;
val test10a = check_pat (TupleP [Wildcard, ConstP 13, Variable "foo", Variable "foo", Wildcard]) = false
val test10b = check_pat (TupleP [Wildcard, ConstP 13, Variable "foo", Variable "fee", Wildcard]) = true

val test11 = match (Const(1), UnitP) = NONE
val test11a = match (Const 1, ConstP 1) = SOME [];
val test11b = match (Const 5, Variable "foo") = SOME [("foo", Const 5)]			     
val test11c = match (Const 5, Wildcard) = SOME []
					       
val test11d = match ((Tuple [Const 5,   Const 13,  Const 42,       Unit,           Const 45]),
		     (TupleP [Wildcard, ConstP 13, Variable "foo", Variable "fee", Wildcard])) =
	      SOME [("fee", Unit), ("foo", Const 42)]
val test11e = match ((Tuple [Const 5,   Const 14,  Const 42,       Unit,           Const 45]),
		     (TupleP [Wildcard, ConstP 13, Variable "foo", Variable "fee", Wildcard])) =
	      NONE
		  
val test11f = match (Constructor ("FOO", Const 5), ConstructorP ("FOO", Variable "foo")) = SOME [("foo", Const 5)];

				   
val test12 = first_match Unit [UnitP] = SOME []
val test12a = first_match (Tuple [Const 15, Unit])
			 [(TupleP [UnitP, ConstP 42]),
			  (TupleP [Wildcard, ConstP 3]),
			  UnitP,
			  (TupleP [Wildcard, Variable "foo"])]
	      = SOME [("foo", Unit)]

val test12b = first_match Unit [ConstP 13, TupleP [UnitP]] = NONE;


