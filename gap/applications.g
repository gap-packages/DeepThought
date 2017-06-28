# This files contains the functions:
#	DTP_SolveEquation
#	DTP_Inverse
#	DTP_Exp
#	DTP_NormalForm
#	DTP_Order
#
#	DTP_IsInNormalForm
#	_DTP_DetermineNormalForm
#	_DTP_DetermineOrder
##############################################################################

# Each application (DTP_SolveEquation, DTP_NormalForm, DTP_Order, ...) may take an 
# DTobj where DTobj[2] is either the output of the function DTP_DTpols_rs or the 
# output of DTP_DTpols_r. Let polynomials := DTobj[2]. 
# Since the condition IsInt(polynomials[1][1][1]) is true if and only if
# "polynomials" is the ouput of DTP_DTpols_r, we can decide which
# multiplication function we should use for computations. Explanation: 
# For DTP_DTpols_r: 
#	polynomials[1] <-> f_1
#	polynomials[1][1] <-> first g_alpha in f_1
#	polynomials[1][1][1] <-> constant coefficient in first g_alpha in f_1
#
# For DTP_DTpols_rs: 
#	polynomials[1] <-> list of the n polynomials f_{r, 1} (1 <= r <= n) 
#	polynomials[1][1] <-> polynomial f_{1, 1}
#	polynomials[1][1][1] <-> first g_alpha in f_{1, 1}, this is a list
#
# Hence, we can determine the suitable multiplication function "multiply"
# by using
# 	if IsInt(DTobj[2][1][1][1]) then 
# 		# version f_r
# 		multiply := DTP_Multiply_r; 
# 	else
# 		# version f_rs 
# 		multiply := DTP_Multiply_rs;
# 	fi; 

# Input: 	- exponent vectors x, z
#			- DTobj
# Output:	exponent vector y such that for the corresponding elements 
#			x * y = z. If DTobj[4] = true, y describes a normal form. 
DTP_SolveEquation := function(x, z, DTobj)
	local y, i, n, multiply;
	
	if IsInt(DTobj[2][1][1][1]) then 
		# version f_r
		multiply := DTP_Multiply_r; 
	else
		# version f_rs 
		multiply := DTP_Multiply_rs;
	fi; 
	
	n := DTobj[1]![PC_NUMBER_OF_GENERATORS];
	y := []; 
	
	# both exponent vectors must have length n 
	if Length(x) <> n or Length(z) <> n then
		Error("Exponent vectors x and z must have length ", n); 
	fi;
	
	for i in [1 .. n] do
		# Loop invariant:
		# x = a_1^z_1 ... a_{i-1}^{z_{i-1}} * a_i^x_i ... a_n^x_n 
		y[i] := z[i] - x[i];
		# calculate x * a_i^y_i
		x := multiply(x, ExponentsByObj(DTobj[1], [i, y[i]]), DTobj); 
	od;
	# Now by the loop invariant: x = z
	# On the other hand: x = x * y by construction
	
	if DTobj[4] then 
		return DTP_NormalForm(y, DTobj);
	else 
		return y;
	fi; 
end; 

# Input: 	- exponent vector x
#			- DTobj
# Output:	exponent vector of x^{-1}. If DTobj[4] = true, y describes a 
#			normal form. 
DTP_Inverse := function(x, DTobj)
	local n; 
	n := DTobj[1]![PC_NUMBER_OF_GENERATORS];
	return DTP_SolveEquation(x, [1 .. n] * 0, DTobj); 
end;

# IsInNormalFrom checks whether the element described by the exponent 
# vector x is in normal form or not. 
# It returns "true", if x describes a normal form and otherwise
# the smallest generator index for which the condition
# 	r[i] <> 0 and (x[i] < 0 or x[i] >= r[i])
# is NOT fulfilled is returned. Here, r = RelativeOrders(coll).
DTP_IsInNormalForm := function(x, coll)
	local i, r; 
	
	r := RelativeOrders(coll); 
	# If the relative order r[i] is finite, check whether 
	# 0 <= x[i] < r[i] is fulfilled. 
	for i in [1 .. coll![PC_NUMBER_OF_GENERATORS]] do 
		if r[i] <> 0 then 
			if x[i] < 0 or x[i] >= r[i] then 
				return i; 
			fi; 
		fi; 
	od; 
	
	return true; 
end; 


# Input: 	- exponent vector x
#			- integer q 
#			- DTobj 
#			- multiplication function multiply (= DTP_Multiply_r or DTP_Multiply_rs)
#			depending on the polynomials used in DTobj
# Output: 	exponent vector of x^q. If DTobj[4] = true, then the result is 
#			in normal form. 
DTP_Exp := function(x, q, DTobj)
	local q_list, l, k, res, multiply; 
	
	if IsInt(DTobj[2][1][1][1]) then 
		# version f_r
		multiply := DTP_Multiply_r; 
	else
		# version f_rs 
		multiply := DTP_Multiply_rs;
	fi; 

	if q < 0 then
    	q_list := -CoefficientsQadic(-q, 2);
	else
    	q_list := CoefficientsQadic(q, 2);
	fi;
	l := Length(q_list) - 1; # q = \sum_{k = 0}^l q_list[k + 1] 2^k
	
	# Compute x^q = \prod_{i = 0}^l x^(q_list[i + 1] * 2^i):
	
	# First compute x^q_list[1], where q_list[1] \in {-1, 0, 1}.
	if q < 0 then
		# If q is negative, we compute (x^{-1})^|q|.
		x := DTP_Inverse(x, DTobj); # x = x^-1
	fi; 
	
	# First step of the computation: 
	if q_list[1] = 0 then # res = 1_G = [0, ..., 0]
		res := [1 .. NumberOfGenerators(DTobj[1])] * 0; 
	else # res = z
		res := x;
	fi;

	# Compute x^|q| = \prod_{k = 0}^l z^(q_list[k + 1] * 2^k)
	for k in [1 .. l] do
		x := multiply(x, x, DTobj);
		if q_list[k + 1] <> 0 then
			res := multiply(res, x, DTobj); 
		fi; 
	od;
	
	return res; 
end; 

# Input: 	- exponent vector x
#			- DTobj
#			- empty list nf = [] where normal form is stored 
#			- function multiply which is either DTP_Multiply_r or DTP_Multiply_rs
#			depending the polynomials used in DTobj
# Output: 	exponent vector of the normal form of x  
_DTP_DetermineNormalForm := function(x, DTobj, nf, multiply)
	local n, j, i, q, r, q_list, l, z, pwr, k, w1, w2, w; 
	
	# DTobj[1] = coll 
	# DTobj[2] = DTpols(coll)
	n := DTobj[1]![PC_NUMBER_OF_GENERATORS]; 
	
	# find j = min{ 1 <= i <= n | s_i < infinity and
	#  							(x_i < 0 or x_i >= s_i) } \cup {infinity}
	j := DTP_IsInNormalForm(x, DTobj[1]);

	if j <> true then 
		# replace a_j^x[j] by suitable power of the power relation a_j^s_j 
		
		# x[j] = q * rel_orders[j] + r, 0 <= r < rel_orders[j]:
		r := x[j] mod RelativeOrders(DTobj[1])[j];
		q := (x[j] - r)/RelativeOrders(DTobj[1])[j];
		
		# In the following, compute w = w1 * w2, where
		# w1 = ( a_j^rel_orders[j] )^q 
		#		 = ( a_{j + 1}^{c_{j, j, j + 1}} ... a_n^{c_{j, j, n}} )^q 
		# and
		# w2 = a_{j + 1}^{x_{j + 1}} ... a_n^{x_n}
		# Then w only depends on the generators a_{j + 1}, ..., a_n and
		# its normal form can be computed (recursively). 
		
		pwr := GetPower(DTobj[1], j); 
		# z = a_{j + 1}^c_{j, j, j + 1} ... a_n^{c_{j, j, n}}
		z := [1 .. n] * 0; 
		for k in [1, 3 .. (Length(pwr) - 1)] do 
			z[pwr[k]] := pwr[k + 1];
		od; 

		# Compute w1 = z^q
		w1 := DTP_Exp(z, q, DTobj);

		# w2 = a_{j + 1}^{x_{j + 1}} ... a_n^{x_n}
		w2 := [1 .. j] * 0; # [0, ..., 0] of length j
		for i in [(j + 1) .. n] do
			Add(w2, x[i]); 
		od;
		
		# w = w1 * w2 
		w := multiply(w1, w2, DTobj); 
		
		# At this point, nf is a list describing the beginning of the exponent
		# vector of the normal form of x. If some relative orders are
		# infinite, the corresponding exponents in x are simply added, and
		# lastly the exponent r of the generator a_j is added. Afterwards,
		# nf is a list of length j, which must be completed in the following
		# recursion steps, in which the normal form of "the rest" w" of x is 
		# computed. 
		for i in [(Length(nf) + 1) .. (j - 1)] do 
			Add(nf, x[i]);
		od;
		Add(nf, r); # j-th entry 

		return _DTP_DetermineNormalForm(w, DTobj, nf, multiply);
	else
		# Since all further relative orders are infinite, the word is 
		# now in normal form and we simply append the exponents to the
		# already calculated normal form nf. 
		for i in [(Length(nf) + 1) .. n] do 
			Add(nf, x[i]);
		od;
		return nf; 
	fi;
end; 

# Input: 	- exponent vector x 
#			- DTobj
# Output: 	exponent vector of normal form of x  
InstallGlobalFunction( DTP_NormalForm, function(x, DTobj)
	if IsInt(DTobj[2][1][1][1]) then 
		# version f_r
		return _DTP_DetermineNormalForm(x, DTobj, [], DTP_Multiply_r);
	else
		# version f_rs 
		return _DTP_DetermineNormalForm(x, DTobj, [], DTP_Multiply_rs);
	fi; 
end );

# Input:	- exponent vector x (must describe a normal form)
#			- DTobj
# Output: 	order of x in group of coll 
_DTP_DetermineOrder := function(x, DTobj, multiply)
	local j, s, ord; 
	ord := 1; 
	# DTobj[1] = coll 
	# DTobj[2] = DTpols(coll)
	
	while x <> [1 .. DTobj[1]![PC_NUMBER_OF_GENERATORS]] * 0 do
		j := 1;
		while x[j] = 0 do
			j := j + 1; # exists, since x <> neutral element
		od; 
		if RelativeOrders(DTobj[1])[j] = 0 then # relative order s_j = infinity 
			return infinity;
		else
			# s = s_j/gcd(s_j, x_j) 
			s := RelativeOrders(DTobj[1])[j]/Gcd(RelativeOrders(DTobj[1])[j], x[j]); 
			
			# ord(x) = infinity <=> ord(x^s) = infinity
			# ord(x) < infinity => s | ord(x)
			
			# Compute y = x^s:
			x := DTP_Exp(x, s, DTobj); 
			# The normal form of x is needed, i.e. isConfl = true! 
			# (Otherwise one may run into a infinite recursion, since the 
			# termination of the algorithm needs the normal form of x to 
			# begin with a generator with index greater than j.)
			ord := ord * s; 
		fi;
	od;
	return ord; 
end; 

# Input: 	- exponent vector x
#			- DTobj
# Output: 	order of x in group of coll 
InstallGlobalFunction( DTP_Order, function(x, DTobj)
	local multiply; 
	
	if IsInt(DTobj[2][1][1][1]) then 
		# version f_r
		multiply := DTP_Multiply_r; 
	else
		# version f_rs 
		multiply := DTP_Multiply_rs;
	fi; 

	# check whether x is in normal form, if not call _DTP_DetermineNormalForm
	if not DTP_IsInNormalForm(x, DTobj[1]) then 
		x := _DTP_DetermineNormalForm(x, DTobj, [], multiply); 
	fi; 
	
	return _DTP_DetermineOrder(x, DTobj, multiply);
end );
