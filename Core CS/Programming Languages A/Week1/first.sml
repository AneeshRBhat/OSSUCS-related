(* This is a comment. This is my first program *)
(* Comments are round parantheses and star*)

val x = 34; (* int *)

(* val keyword for variable *)

val y = 17;

val z = (x + y) + (y + 2);

val abs_of_z = if z < 0
	       then 0 - z
	       else z;

val abs_of_z_simpler = abs z;

val is_greater = if 8 > 9 then 9 else 8;
