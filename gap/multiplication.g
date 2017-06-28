# This file contains the functions:
#	DTP_Multiply_rs 
#	DTP_Multiply_s 
#	DTP_EvalPol_rs
#
#	DTP_Multiply_r 
#	DTP_Multiply_rsEvalPol_r
#
#	DTP_CollectWordOrFail 
#############################################################################

#############################################################################
####					Multiplication with f_rs						 ####
#############################################################################

# evaluate polynomial pol = f_rs on input z = [z_1, ..., z_n] and y_s:
# (a_1^z_1 * ... * a_n^z_n ) * a_s^y_s = a_1^res[1] * ... a_n^res[n] 
DTP_EvalPol_rs := function(pol, z, y_s)
	local res, summand, i, j; 
	
	res := 0; 
	
	for i in [1 .. Length(pol)] do
		summand := pol[i][1]; 
		for j in [2 .. Length(pol[i])] do
		
			Assert(1, pol[i][j][2] >= 0); # pol[i][j][2] = |A| for an 
			# equivalence class of Sub(alpha) for a letter alpha
			
			if pol[i][j][1] <= Length(z) then # Length(z) = n
				summand := summand * Binomial(z[pol[i][j][1]], pol[i][j][2]); 
			else # If the number of the indeterminate is greater than n, it 
			# must be Y_s, since it is the only indeterminate corresponding 
			# to an indeterminate Y_{} in f_rs 
				summand := summand * Binomial(y_s, pol[i][j][2]);
			fi;
			
		od; 
		res := res + summand; 
	od;
	
	return res; 
end;

# Input: 	- exponent vector z (arbitrary) 
#			- list elm_s = [s, y_s] representing element a_s^y_s
#			- DTobj
# Output: 	exponent vector [res_1, ..., res_n] such that 
#			(a_1^z[1] ... a_n^z[n]) * a_s^y_s = a_1^res[1] ... a_n^res[n]
DTP_Multiply_s := function(z, elm_s, DTobj)
	local n, res, r, s, orders;
	
	n := DTobj[1]![PC_NUMBER_OF_GENERATORS];	
	s := elm_s[1]; 
	orders := DTobj[3]; 
	res := [];
	
	# use Prop. 2.5.3 for 1 <= r <= s: 
	for r in [1 .. s - 1] do 
		if orders[r] < infinity then 
			Add(res, z[r] mod orders[r]); # z_r = x_r
		else
			Add(res, z[r]); # z_r = x_r
		fi; 
	od;
	if orders[s] < infinity then 
		Add(res, (z[s] + elm_s[2]) mod orders[s]); # z_s = x_s + y_s
	else
		Add(res, z[s] + elm_s[2]); # z_s = x_s + y_s
	fi; 
	
	for r in [s + 1 .. n] do 
		# evaluate polynomial f_rs on x and y[s] 
		if orders[r] < infinity then 
			Add(res, DTP_EvalPol_rs(DTobj[2][s][r], z, elm_s[2]) mod orders[r]);
			# This takes almost the same time as reducing the orders also
			# in every step in DTP_EvalPol_rs. 
		else
			Add(res, DTP_EvalPol_rs(DTobj[2][s][r], z, elm_s[2])); 
		fi; 
	od; 
	
	# Notice that "res" may NOT be in normal form, since it is more efficient
	# to compute the normal form only once in multiply_rs. 
	return res; 
end; 

# Input: 	- exponent vectors x, y (arbitrary)
#			- DTobj
# Output:	If DTobj[4] = true, the exponent vector of the 
#			product x * y is returned in normal form. Otherwise, the exponent
#			vector is a reduced word.
DTP_Multiply_rs := function(x, y, DTobj)
	local n, s; 
	
	n := DTobj[1]![PC_NUMBER_OF_GENERATORS]; 
	
	# check that both exponent vectors x, y have correct length 
	if Length(x) <> n or Length(y) <> n then
		Error("Exponent vectors x and y must have length ", n); 
	fi;
	
	for s in [1 .. n] do
		# compute ( x * a_1^y[1] ... a_{s-1}^y[s-1] ) * a_s^y[s]
		x := DTP_Multiply_s(x, [s, y[s]], DTobj); 
	od;
	
	if DTobj[4] = true then 
		# If the collector is consistent, return the normal form. 
		return DTP_NormalForm(x, DTobj); 
	else 
		# If the collector is not consistent, return the result as a reduced 
		# word. 
		return x; 
	fi; 
end; 

#############################################################################
####					Multiplication with f_r							 ####
#############################################################################

# evaluate polynomial f_r on input x, y
DTP_Multiply_rsEvalPol_r := function(pol, x, y)
	local res, summand, i, j, n; 
	
	n := Length(x); 
	res := 0; 
	
	for i in [1 .. Length(pol)] do # pol[i] <-> g_alpha
		summand := pol[i][1]; # constant coefficient
		for j in [2 .. Length(pol[i])] do
			Assert(1, pol[i][j][2] >= 0); # pol[i][j][2] = |A| for an 
			# equivalence class of Sub(alpha) for a letter alpha
			if pol[i][j][1] <= n then 
				summand := summand * Binomial(x[pol[i][j][1]], pol[i][j][2]); 
			else # If the number of the indeterminate is greater than n, it 
			# is a Y_s = Y_{n + r} 1 <= r <= n
				summand := summand * Binomial(y[pol[i][j][1] - n], pol[i][j][2]);
			fi;
			
		od; 
		res := res + summand; 
	od;
	
	return res; 
end;

# Input: 	- exponent vectors x, y (arbitrary)
#			- DTobj
# Output:	If DTobj[4] = true, the exponent vector of the 
#			product x * y is returned in normal form. Otherwise, the exponent
#			vector is a reduced word.
DTP_Multiply_r := function(x, y, DTobj)
	local n, r, s, pol, z, orders; 
	
	n := DTobj[1]![PC_NUMBER_OF_GENERATORS];
	orders := DTobj[3]; 
	
	# check that both exponent vectors x, y have correct length 
	if Length(x) <> n or Length(y) <> n then
		Error("Exponent vectors x and y must have length ", n); 
	fi;
	
	z := [];  
	for r in [1 .. n] do 
		# evaluate polynomial f_r
		if orders[r] < infinity then 
			Add(z, DTP_Multiply_rsEvalPol_r(DTobj[2][r], x, y) mod orders[r]);
		else
			Add(z, DTP_Multiply_rsEvalPol_r(DTobj[2][r], x, y));
		fi; 
	od;
	
	if DTobj[4] = true then 
		# If the collector is consistent, return the normal form. 
		return DTP_NormalForm(z, DTobj); 
	else 
		# If the collector is not consistent, return the result as a reduced 
		# word. 
		return z; 
	fi; 
end; 
