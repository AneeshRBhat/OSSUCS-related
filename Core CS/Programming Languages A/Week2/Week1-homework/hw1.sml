(* Homework 1 Solution File *)
(* ----------------------------------------------- *)
(* Problem 1 *)

(* (int*int*int) * (int*int*int) -> bool *)
(* Produce true if d1 comes before d2 *)

fun is_older (d1: (int*int*int), d2: (int*int*int)) =
    ((#1 d1) < (#1 d2)                          (* is year1 less than year2, return true*)
     orelse
     ((#1 d1) = (#1 d2)                         (* else, if year1 = year2 *)
      andalso ((#2 d1) < (#2 d2)                (* and month1 < month 2, return true *)
	       orelse          
	       ((#2 d1) = (#2 d2)               (* else, if month1 = month2 *)
		andalso
		(#3 d1) < (#3 d2)))));	        (* and day1 < day2, return true,
						   false otherwise *)

(* ------------------------------------------------ *)
(* Problem 2 *)

(* (int*int*int) list * int -> int *)
(* Produce the number of dates in the list which fall on the
   given month *) 

fun number_in_month (ds: (int*int*int) list, m:int) =
    if null ds
    then 0
    else
	let
	    val rest_list_number = number_in_month ((tl ds), m)
	in
	     if (m = (#2 (hd ds)))
	     then (1 + rest_list_number)
	     else rest_list_number
	end;
		 
(* ----------------------------------------------------- *)
(* Problem 3 *)

(* (int*int*int) list * int list -> int *)
(* Produce the number of dates in ds that fall on 
   any of the months in ms *)

fun number_in_months (ds: (int*int*int) list, ms: int list) =
    if null ms
    then 0
    else
	let
	    val rest_month_count = number_in_months(ds, tl ms)
	in
	    number_in_month (ds, hd ms) + rest_month_count
	end;

(* --------------------------------------------------------- *)
(* Problem 4 *)

(* (int*int*int) list * int -> (int*int*int) list *)
(* Produce a list of dates from the given dates that fall
   given month *)

fun dates_in_month (ds: (int*int*int) list, m: int) =
    if null ds
    then []
    else
	if (#2 (hd ds) = m)
	then (hd ds)::dates_in_month(tl ds, m)
	else dates_in_month(tl ds, m);

(* ----------------------------------------------------------- *)
(* Problem 5 *)

(* (int*int*int) list * int list -> (int*int*int) list *)
(* Produce a list of dates from ds that fall on any
   month from the ms *)

fun dates_in_months (ds: (int*int*int) list, ms: int list) =
    if null ms
    then []
    else dates_in_month(ds, hd ms)
	 @
	 dates_in_months(ds, tl ms);

(* ----------------------------------------------------------- *)
(* Problem 6 *)

(* string list * int -> string *)
(* Produce the nth element of the list ss *)
(* The hd of the list is the 1st element *)

fun get_nth (ss: string list, n: int) =
    if (n-1 = 0)
    then (hd ss)
    else get_nth (tl ss, n-1);


(* ----------------------------------------------------------- *)
(* Problem 7 *)

val month_list = ["January",
		  "February",
		  "March",
		  "April",
		  "May",
		  "June",
		  "July",
		  "August",
		  "September",
		  "October",
		  "November",
		  "December"];

(* (int*int*int) list -> string *)
(* Produce a string of the form "Day Month, Year" from the 
   consumed date *)

fun date_to_string (d: (int*int*int)) =
    let
	val day_string = Int.toString (#3 d)^ ", ";
	val year_string = Int.toString (#1 d);
	val month_string = get_nth(month_list, #2 d)^ " ";
    in
	month_string ^ day_string ^ year_string
    end;

(* ----------------------------------------------------------- *)
(* Problem 8 *)

(* int * int list -> int *)
(* Produce a n such that the first n elements of is add up to 
   less than sum, and first n+1 elements add up to sum or more *)

fun number_before_reaching_sum (sum: int, is0: int list) =
    (* rsf is a int: context preserving accumulator; sum of
       	      	     numbers visited to far in the list *)
    (* acc is a int: context preserving accumulator; number of 
                     elements visited so far in the list*)
    let
	fun track_sum (is: int list, rsf: int, acc: int) =
	    let val new_result = rsf + hd is
	    in
		if new_result >= sum
		then acc
		else track_sum (tl is, new_result, acc+1)
	    end
	
    in
	track_sum(is0, 0, 0)
    end;

(* ------------------------------------------------------ *)
(* Problem 9 *)

val days_in_months = [31,28,31,30,31,30,31,31,30,31,30,31]

(* int[1,365] -> int[1,12] *)
(* Produce the month number from the given day *)

fun what_month (day: int) =
    number_before_reaching_sum (day, days_in_months) + 1;

(* -------------------------------------------------------- *)
(* Problem 10 *)

(* int * int -> int list *)
(* Produce a list of the months that fall between the months of d1 and d2 *)

fun month_range (d1: int, d2: int) =
    if d1 > d2
    then []
    else what_month d1::(month_range (d1+1, d2));

(* -------------------------------------------------------- *)
(* Problem 11 *)

(* (int*int*int) list -> (int*int*int) OPTION *)
(* Produce the oldest date in a list of dates, NONE if the list
   is empty *)

fun oldest (ds0: (int*int*int) list) =
    if null ds0
    then NONE
    else
	let
	    fun oldest_date (ds: (int*int*int) list) =
		if null (tl ds)
		then hd ds
		else
		    let val tl_oldest = oldest_date (tl ds)
		    in
			if is_older (hd ds, tl_oldest)
			then hd ds
			else tl_oldest
		    end
			
	in
	    SOME (oldest_date ds0)
	end;


(* ------------------------------------------------------------------------- *)
(* Problem 12: Challenge Problem *)

(* (int*int*int) list * int list -> int *)

fun number_in_months_challenge(ds: (int*int*int) list,  ms: int list) =
    let
	fun occured (e: int, rsf: int list) =
	    if null rsf
	    then false
	    else
		if e = hd rsf
		then true
		else occured (e, tl rsf)
	    
	fun remove_duplicates (ms: int list, rsf: int list) =
	    if null ms
	    then rsf
	    else
		if (not (occured (hd ms, rsf)))
		then remove_duplicates (tl ms, (hd ms::rsf))
		else remove_duplicates (tl ms, rsf)
					   
	val no_duplicate_list = remove_duplicates (ms, [])			
    in
	number_in_months(ds, no_duplicate_list)
    end;


(* (int*int*int) list * int list -> (int*int*int) list *)
fun dates_in_months_challenge (ds: (int*int*int) list, ms: int list) =
     let
	fun occured (e: int, rsf: int list) =
	    if null rsf
	    then false
	    else
		if e = hd rsf
		then true
		else occured (e, tl rsf)
	    
	fun remove_duplicates (ms: int list, rsf: int list) =
	    if null ms
	    then rsf
	    else
		if (not (occured (hd ms, rsf)))
		then remove_duplicates (tl ms, (hd ms::rsf))
		else remove_duplicates (tl ms, rsf)
					   
	val no_duplicate_list = remove_duplicates (ms, [])			
    in
	dates_in_months (ds, no_duplicate_list)
    end;
    
(* ------------------------------------------------------------ *)
(* Problem 13 *)

(* (int*int*int) -> bool *)

fun reasonable_date (d: (int*int*int)) =
    let
	val months_31 = [1,3,5,7,8,10,12]
	fun has_31 (m: int, ms: int list) =
	    if null ms
	    then false
	    else
		if m = hd ms
		then true
		else has_31 (m, tl ms)			    
    in
	if ((#1 d) > 0) andalso ((#2 d) > 1 andalso (#2 d) <= 12) andalso (#3 d) > 0
	then
	    if (#2 d) = 2
	    then
		if (((#1 d) mod 4 = 0) orelse ((#1 d) mod 400 = 0)) andalso ((#1 d) mod 100 <> 0)
		then
		    (#3 d) <= 29
		else
		    (#3 d) <= 28
	    else
		if has_31 (#2 d, months_31)
		then (#3 d) <= 31
		else (#3 d) <= 30	    
	else false
    end;


	
