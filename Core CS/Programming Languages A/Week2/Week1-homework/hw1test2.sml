use "hw1.sml";

val test8a = number_before_reaching_sum (1, [2]) = 0
						       
val test8b = number_before_reaching_sum (2, [1, 1]) = 1
							  
val test8c = number_before_reaching_sum (5, [1, 2, 3]) = 2
							     
val test8d = number_before_reaching_sum (10, [1, 2, 3, 4, 5]) = 3
val test8e = number_before_reaching_sum (20,
					 [2, 3, 4, 5, 6, 4, 5, 6])
	     = 4
val test8f = number_before_reaching_sum (20, [6, 2, 5, 3, 4, 2, 7, 1]) = 4
