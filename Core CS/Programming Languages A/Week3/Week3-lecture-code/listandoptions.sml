datatype ListOfInt = Empty | Cons of int * ListOfInt

val x = Cons(4, Cons (23, Cons(2008, Empty)))
val y = Cons(3, Cons (2, Cons (1, Empty)))
	    
fun append (xs,ys) = 
	   case xs of
	       Empty => ys
	     | Cons(x,xs') => Cons (x, append (xs', ys))

fun append2 (xs: int list, ys: int list) =
    case xs of
	[] => ys
      | x::xs' => x :: append2 (xs',ys)

val x1 = [1,2,3,4]
val x2 = [3,4,5,6]
	     			    
