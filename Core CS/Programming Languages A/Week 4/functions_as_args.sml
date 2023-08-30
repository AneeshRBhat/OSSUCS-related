fun n_times(f, n, x) =
    if n = 0
    then x
    else f(n_times(f, n-1, x))

fun increment x = x+1
fun double x = x*2

val x1 = n_times(double, 4, 7)
val x2 = n_times(increment, 4, 7)
val x3 = n_times(tl, 2, [4,3,6,7,8])
		
