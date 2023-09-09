fun sorted_3tupled (x,y,z) = z>=y andalso y >= x

val t1 = sorted_3tupled (7, 9, 11)

val sorted3 = fn x => fn y => fn z => z >= y andalso y >=x

val t2 = ((( sorted3 7) 9) 11)

val t3 = sorted3 7 9 11

fun sorted3_nicer x y z = z>=y andalso y>=x

val t4 = sorted3_nicer 4 5 6
		       
