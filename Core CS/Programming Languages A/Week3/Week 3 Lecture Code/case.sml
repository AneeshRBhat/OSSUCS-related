datatype mytype = TwoInts of int*int
		| Str of string
		| Pizza

(* mytype -> int *)

fun f (x: mytype) = 
    case x of
	Pizza => 3
      | Str s =>  8
      | TwoInts(i1,i2)  =>  i1+i2;

(* Pattern Matching -> Built from the same constructor *)
(* find which branch matches, then bind the value to local variables, 
   then evaluate the expression on the right, and return that value *)

(*
case e0 of
    p1 => e1
  | p2 => e2
  | ...
  | pn => en
*)
