# This file contains the functions:
#	DTP_Multiply_rs
#	DTP_Multiply_s
#	DTP_EvalPol_rs
#
#	DTP_Multiply_r
#	DTP_EvalPol_r
#
#	DTP_Multiply
#############################################################################

#############################################################################
####					Multiplication with f_rs						 ####
#############################################################################

# evaluate polynomial pol = f_rs on input z = [z_1, ..., z_n] and y_s:
# (a_1^z_1 * ... * a_n^z_n ) * a_s^y_s = a_1^res[1] * ... a_n^res[n]
DTP_EvalPol_rs := function(pol, z, y_s)
	local res, summand, g_alpha, j;

	res := 0;

	for g_alpha in pol do
		summand := g_alpha[1];
		for j in [2 .. Length(g_alpha)] do

			Assert(1, g_alpha[j][2] >= 0); # g_alpha[j][2] = |A| for an
			# equivalence class of Sub(alpha) for a letter alpha

			if g_alpha[j][1] <= Length(z) then # Length(z) = n
				summand := summand * Binomial(z[g_alpha[j][1]], g_alpha[j][2]);
			else # If the number of the indeterminate is greater than n, it
			# must be Y_s, since it is the only indeterminate corresponding
			# to an indeterminate Y_{} in f_rs
				summand := summand * Binomial(y_s, g_alpha[j][2]);
			fi;

		od;
		res := res + summand;
	od;

	return res;
end;

# Input: 	- exponent vector z (arbitrary)
#			- list elm_s = [s, y_s] representing element a_s^y_s
#			- DTObj
# Output: 	exponent vector [res_1, ..., res_n] such that
#			(a_1^z[1] ... a_n^z[n]) * a_s^y_s = a_1^res[1] ... a_n^res[n]
DTP_Multiply_s := function(z, elm_s, DTObj)
	local n, res, r, s, orders;

	n := DTObj![PC_NUMBER_OF_GENERATORS];
	s := elm_s[1];
	orders := DTObj![PC_DTPOrders];
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
			Add(res, DTP_EvalPol_rs(DTObj![PC_DTPPolynomials][s][r], z, elm_s[2]) mod orders[r]);
			# This takes almost the same time as reducing the orders also
			# in every step in DTP_EvalPol_rs.
		else
			Add(res, DTP_EvalPol_rs(DTObj![PC_DTPPolynomials][s][r], z, elm_s[2]));
		fi;
	od;

	# Note that "res" may NOT be in normal form, since it is more efficient
	# to compute the normal form only once in multiply_rs.
	return res;
end;

# Input: 	- exponent vectors x, y (arbitrary)
#			- DTObj
# Output:	If DTObj![PC_DTPConfluent] = true, the exponent vector of the
#			product x * y is returned in normal form. Otherwise, the exponent
#			vector is a reduced word.
InstallGlobalFunction( DTP_Multiply_rs,
function(x, y, DTObj)
	local n, s;

	n := DTObj![PC_NUMBER_OF_GENERATORS];

	# check that both exponent vectors x, y have correct length
	if Length(x) <> n or Length(y) <> n then
		Error("Exponent vectors x and y must have length ", n);
	fi;

	for s in [1 .. n] do
		# compute ( x * a_1^y[1] ... a_{s-1}^y[s-1] ) * a_s^y[s]
		x := DTP_Multiply_s(x, [s, y[s]], DTObj);
	od;

	if DTObj![PC_DTPConfluent] = true then
		# If the collector is consistent, return the normal form.
		return DTP_NormalForm(x, DTObj);
	else
		# If the collector is not consistent, return the result as a reduced
		# word.
		return x;
	fi;
end);

#############################################################################
####					Multiplication with f_r							 ####
#############################################################################

# evaluate polynomial pol = f_r on exponent vectors x, y
DTP_EvalPol_r := function(pol, x, y)
	local res, summand, g_alpha, j, n;

	n := Length(x);
	res := 0;

	for g_alpha in pol do # pol[i] <-> g_alpha
		summand := g_alpha[1]; # constant coefficient
		for j in [2 .. Length(g_alpha)] do
			Assert(1, g_alpha[j][2] >= 0); # g_alpha[j][2] = |A| for an
			# equivalence class of Sub(alpha) for a letter alpha
			if g_alpha[j][1] <= n then
				summand := summand * Binomial(x[g_alpha[j][1]], g_alpha[j][2]);
			else # If the number of the indeterminate is greater than n, it
			# is a Y_s = Y_{n + r} 1 <= r <= n
				summand := summand * Binomial(y[g_alpha[j][1] - n], g_alpha[j][2]);
			fi;

		od;
		res := res + summand;
	od;

	return res;
end;

# Input: 	- exponent vectors x, y (arbitrary)
#			- DTObj
# Output:	If DTObj![PC_DTPConfluent] = true, the exponent vector of the
#			product x * y is returned in normal form. Otherwise, the exponent
#			vector is a reduced word.
InstallGlobalFunction( DTP_Multiply_r,
function(x, y, DTObj)
	local n, r, s, pol, z, orders;

	n := DTObj![PC_NUMBER_OF_GENERATORS];
	orders := DTObj![PC_DTPOrders];

	# check that both exponent vectors x, y have correct length
	if Length(x) <> n or Length(y) <> n then
		Error("Exponent vectors x and y must have length ", n);
	fi;

	z := [];
	for r in [1 .. n] do
		# evaluate polynomial f_r
		if orders[r] < infinity then
			Add(z, DTP_EvalPol_r(DTObj![PC_DTPPolynomials][r], x, y) mod orders[r]);
		else
			Add(z, DTP_EvalPol_r(DTObj![PC_DTPPolynomials][r], x, y));
		fi;
	od;

	if DTObj![PC_DTPConfluent] = true then
		# If the collector is consistent, return the normal form.
		return DTP_NormalForm(z, DTObj);
	else
		# If the collector is not consistent, return the result as a reduced
		# word.
		return z;
	fi;
end);


#############################################################################
####					General Multiplication							 ####
#############################################################################

# Input: 	- exponent vectors x, y (arbitrary)
#			- DTObj
# Output:	If DTObj![PC_DTPConfluent] = true, the exponent vector of the
#			product x * y is returned in normal form. Otherwise, the exponent
#			vector is a reduced word.
#			The functions determines whether f_rs or f_r were computed and
#			calls DTP_Multiply_rs or DTP_Multiply_r, respectively.
InstallGlobalFunction( DTP_Multiply,
function(x, y, DTObj)
	if IsInt(DTObj![PC_DTPPolynomials][1][1][1]) then
		# version f_r
		return DTP_Multiply_r(x, y, DTObj);
	else
		# version f_rs
		return DTP_Multiply_rs(x, y, DTObj);
	fi;
end);
