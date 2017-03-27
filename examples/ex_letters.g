alpha := rec( left := rec( left := rec( left := rec( num := 2, pos := 2, side := DT_left), right := rec( num := 1, pos := 1, side := DT_right), num := 4, pos := 1), right := rec( num := 1, pos := 2, side := DT_right), num := 6, pos := 1), right := rec( left := rec( left := rec(num := 2, pos := 2, side := DT_left), right := rec( num := 1, pos := 1, side := DT_right), num := 4, pos := 3), right := rec( num := 1, pos := 3, side := DT_right), num := 5, pos := 1), num := 12, pos := 2); 

alpha_least := rec( left := rec( left := rec( left := rec( num := 2, pos := 1, side := DT_left), right := rec( num := 1, pos := 1, side := DT_right), num := 4, pos := 1), right := rec( num := 1, pos := 2, side := DT_right), num := 6, pos := 1), right := rec( left := rec( left := rec(num := 2, pos := 1, side := DT_left), right := rec( num := 1, pos := 1, side := DT_right), num := 4, pos := 2), right := rec( num := 1, pos := 3, side := DT_right), num := 5, pos := 1), num := 12, pos := 1); 

beta_least := rec( left := rec( left := rec( left := rec( num := 2, pos := 1, side := DT_left), right := rec( num := 1, pos := 1, side := DT_right), num := 4, pos := 1), right := rec( num := 1, pos := 2, side := DT_right), num := 6, pos := 1), right := rec( left := rec( left := rec(num := 2, pos := 1, side := DT_left), right := rec( num := 1, pos := 1, side := DT_right), num := 4, pos := 2), right := rec( num := 1, pos := 3, side := DT_right), num := 5, pos := 1), num := 12, pos := 1); 

gamma := rec( num := 3, pos := 2, side := DT_right);

# beta1 occurs to the left of beta2 occurs to the left of beta3
beta1 := rec( left := rec( num := 2, pos := 1, side := DT_left), right := rec( num := 1, pos := 2, side := DT_right), num := 3, pos := 1);

beta2 := rec( left := rec( num := 2, pos := 1, side := DT_left), right := rec( num := 1, pos := 1, side := DT_right), num := 3, pos := 2);

beta3 := rec( left := rec( left := rec( num := 2, pos := 1, side := DT_left), right := rec( num := 1, pos := 1, side := DT_right), num := 3, pos := 2), right := rec( num := 2, pos := 1, side := DT_right), num := 4, pos := 1);

gamma1 := rec( left := rec( left := rec( num := 2, pos := 2, side := DT_left), right := rec( num := 1, pos := 1, side := DT_right), num := 4, pos := 1), right := rec( num := 2, pos := 1, side := DT_left), num := 6, pos := 1); 

gamma2 := rec( left := rec( num := 5, pos := 1, side := DT_left), right := rec( left := rec( num := 5, pos := 2, side := DT_left), right := rec( num := 1, pos := 1, side := DT_right), num := 2, pos := 1), num := 7, pos := 1);

###

alpha := rec( left := rec( left := rec( left := rec( num := 2, pos := 2, side := DT_left, l := 1), right := rec( num := 1, pos := 1, side := DT_right, l := 1), num := 4, pos := 1, l := 3), right := rec( num := 1, pos := 2, side := DT_right, l := 1), num := 6, pos := 1, l := 5), right := rec( left := rec( left := rec(num := 2, pos := 2, side := DT_left, l := 1), right := rec( num := 1, pos := 1, side := DT_right, l := 1), num := 4, pos := 3, l := 3), right := rec( num := 1, pos := 3, side := DT_right, l := 1), num := 5, pos := 1, l := 5), num := 12, pos := 2, l := 11); 

alpha_least := rec( left := rec( left := rec( left := rec( num := 2, pos := 1, side := DT_left), right := rec( num := 1, pos := 1, side := DT_right), num := 4, pos := 1), right := rec( num := 1, pos := 2, side := DT_right), num := 6, pos := 1), right := rec( left := rec( left := rec(num := 2, pos := 1, side := DT_left), right := rec( num := 1, pos := 1, side := DT_right), num := 4, pos := 2), right := rec( num := 1, pos := 3, side := DT_right), num := 5, pos := 1), num := 12, pos := 1); 

beta_least := rec( left := rec( left := rec( left := rec( num := 2, pos := 1, side := DT_left), right := rec( num := 1, pos := 1, side := DT_right), num := 4, pos := 1), right := rec( num := 1, pos := 2, side := DT_right), num := 6, pos := 1), right := rec( left := rec( left := rec(num := 2, pos := 1, side := DT_left), right := rec( num := 1, pos := 1, side := DT_right), num := 4, pos := 2), right := rec( num := 1, pos := 3, side := DT_right), num := 5, pos := 1), num := 12, pos := 1); 

gamma := rec( num := 3, pos := 2, side := DT_right, l := 1);

# beta1 occurs to the left of beta2 occurs to the left of beta3
beta1 := rec( left := rec( num := 2, pos := 1, side := DT_left, l := 1), right := rec( num := 1, pos := 2, side := DT_right, l := 1), num := 3, pos := 1, l := 3);

beta2 := rec( left := rec( num := 2, pos := 1, side := DT_left), right := rec( num := 1, pos := 1, side := DT_right), num := 3, pos := 2);

beta3 := rec( left := rec( left := rec( num := 2, pos := 1, side := DT_left, l := 1), right := rec( num := 1, pos := 1, side := DT_right, l := 1), num := 3, pos := 2, l := 3), right := rec( num := 2, pos := 1, side := DT_right, l := 1), num := 4, pos := 1, l := 5);

gamma1 := rec( left := rec( left := rec( num := 2, pos := 2, side := DT_left), right := rec( num := 1, pos := 1, side := DT_right), num := 4, pos := 1), right := rec( num := 2, pos := 1, side := DT_left), num := 6, pos := 1); 

gamma2 := rec( left := rec( num := 5, pos := 1, side := DT_left), right := rec( left := rec( num := 5, pos := 2, side := DT_left), right := rec( num := 1, pos := 1, side := DT_right), num := 2, pos := 1), num := 7, pos := 1);