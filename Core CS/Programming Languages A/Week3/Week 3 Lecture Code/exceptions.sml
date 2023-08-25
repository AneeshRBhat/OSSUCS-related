fun hd xs =
    case xs of
	 [] => raise List.Empty
       | x::_  => x;

exception MyUndesirableCondition

exception MyOtherException of int*int

fun mydiv (x,y) = 
	  if y=0
	  then raise MyUndesirableCondition
	  else x div y



