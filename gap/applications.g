# This files contains the functions: 
#   DTP_SolveEquation 
#   DTP_Inverse 
#	DTP_Exp 
#   DTP_NormalForm 
#   DTP_Order 
# 
#	DTP_DetermineMultiplicationFunction 
#   DTP_IsInNormalForm 
#	_DTP_DetermineNormalForm 
#   _DTP_DetermineOrder 
# 
#   DTP_PCP_SolveEquation 
#	DTP_PCP_Inverse 
#   DTP_PCP_Exp 
#   DTP_PCP_NormalForm 
#   DTP_PCP_Order
##############################################################################

# Each application (DTP_SolveEquation, DTP_NormalForm, DTP_Order, ...) may 
# take an DTObj where DTObj![PC_DTPPolynomials] is either the output of the 
# function DTP_DTpols_rs or the output of DTP_DTpols_r. Let 
# polynomials := DTObj![PC_DTPPolynomials]. 
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
# 	if IsInt(DTObj![PC_DTPPolynomials][1][1][1]) then 
# 		# version f_r
# 		multiply := DTP_Multiply_r; 
# 	else
# 		# version f_rs 
# 		multiply := DTP_Multiply_rs;
# 	fi; 
# Input: 	DTObj
# Output: 	function DTP_Multiply_r or DTP_Multiply_rs depending on whether
#			polynomials f_r or f_rs were computed for DTObj. 
InstallGlobalFunction( DTP_DetermineMultiplicationFunction, 
function(DTObj)
	if IsInt(DTObj![PC_DTPPolynomials][1][1][1]) then 
		# version f_r
		return DTP_Multiply_r; 
	else
		# version f_rs 
		return DTP_Multiply_rs;
	fi; 
end) ; 

# Input: 	- exponent vectors x, z
#			- DTObj
# Output:	exponent vector y such that for the corresponding elements 
#			x * y = z. If DTObj![PC_DTPConfluent] = true, y describes a normal 
#			form. 
InstallGlobalFunction( DTP_SolveEquation, 
function(x, z, DTObj)
	local y, i, n, multiply;
	
	multiply := DTP_DetermineMultiplicationFunction(DTObj); 
	
	n := DTObj![PC_NUMBER_OF_GENERATORS];
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
		x := multiply(x, ExponentsByObj(DTObj, [i, y[i]]), DTObj); 
	od;
	# Now by the loop invariant: x = z
	# On the other hand: x = x * y by construction
	
	if DTObj![PC_DTPConfluent] then 
		return DTP_NormalForm(y, DTObj);
	else 
		return y;
	fi; 
end) ; 

# Input: 	pcp elements pcp1, pcp2 belonging to the same collector 
# Output:	pcp element res such that pcp1 * res = pcp2  
InstallGlobalFunction( DTP_PCP_SolveEquation, 
function(pcp1, pcp2)
	local dtobj; 
	
	dtobj := Collector(pcp1);
	
	if not IsDTObj(dtobj) then 
		Error("Collector(pcp1) must be a DTObj");
	elif not Collector(pcp2) = dtobj then 
		Error("pcp1 and pcp2 must belong to the same DTObj"); 
	else
		return PcpElementByExponentsNC(dtobj, DTP_SolveEquation(Exponents(pcp1), Exponents(pcp2), dtobj));
	fi; 
	
end );

# Input: 	- exponent vector x
#			- DTObj
# Output:	exponent vector of x^{-1}. If DTObj![PC_DTPConfluent] = true, y 
#			describes a normal form. 
InstallGlobalFunction( DTP_Inverse, 
function(x, DTObj)
	local n; 
	n := DTObj![PC_NUMBER_OF_GENERATORS];
	return DTP_SolveEquation(x, [1 .. n] * 0, DTObj); 
end) ; 

# Input: 	pcp element pcp
# Output:	inverse of pcp as pcp element  
InstallGlobalFunction( DTP_PCP_Inverse, 
function(pcp)
	local dtobj; 
	
	dtobj := Collector(pcp);
	
	if not IsDTObj(dtobj) then 
		Error("Collector(pcp) must be a DTObj");
	else
		return PcpElementByExponentsNC(dtobj, DTP_Inverse(Exponents(pcp), dtobj)); 
	fi; 
	
end );

# DTP_IsInNormalFrom checks whether the element described by the exponent 
# vector x is in normal form or not. 
# It returns "true", if x describes a normal form and otherwise
# the smallest generator index for which the condition
# 	r[i] <> 0 and (x[i] < 0 or x[i] >= r[i])
# is NOT fulfilled is returned. Here, r = RelativeOrders(coll).
InstallGlobalFunction( DTP_IsInNormalForm, 
function(x, coll)
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
end) ; 


# Input: 	- exponent vector x
#			- integer q 
#			- DTObj 
# Output: 	exponent vector of x^q. If DTObj![PC_DTPConfluent] = true, then
#			the result is in normal form. 
InstallGlobalFunction( DTP_Exp, 
function(x, q, DTObj)
	local multiply, y;  

	multiply := DTP_DetermineMultiplicationFunction(DTObj); 
	y := [1 .. NumberOfGenerators(DTObj)] *0; # y = 1
	if q < 0 then 
		x := DTP_Inverse(x, DTObj);
		q := -q; 
	fi; 
	while q > 0 do 
		if q mod 2 = 1 then 
			y := multiply(y, x, DTObj);
		fi; 
		q := QuoInt(q, 2);
		x := multiply(x, x, DTObj);
	od;
	return y;  
end) ; 

# Input: 	- pcp element pcp
#			- integer q 
# Output:	pcp^q
InstallGlobalFunction( DTP_PCP_Exp, 
function(pcp, q)
	local dtobj, exp; 
	
	dtobj := Collector(pcp);
	
	if not IsDTObj(dtobj) then 
		Error("Collector(pcp) must be a DTObj");
	else
		exp := ShallowCopy(Exponents(pcp));
		return PcpElementByExponentsNC(dtobj, DTP_Exp(exp, q, dtobj)); 
	fi; 
	
end );

# Input: 	- exponent vector x
#			- DTObj
#			- empty list nf = [] where normal form is stored 
#			- function multiply which is either DTP_Multiply_r or 
#			DTP_Multiply_rs depending the polynomials used in DTObj
# Output: 	exponent vector of the normal form of x  
_DTP_DetermineNormalForm := function(x, DTObj, nf, multiply)
	local n, j, i, q, r, q_list, l, z, pwr, k, w1, w2, w; 
	
	# DTObj![PC_DTPPolynomials] = DTpols(coll)
	n := DTObj![PC_NUMBER_OF_GENERATORS]; 
	
	# find j = min{ 1 <= i <= n | s_i < infinity and
	#  							(x_i < 0 or x_i >= s_i) } \cup {infinity}
	j := DTP_IsInNormalForm(x, DTObj);

	if j <> true then 
		# replace a_j^x[j] by suitable power of the power relation a_j^s_j 
		
		# x[j] = q * rel_orders[j] + r, 0 <= r < rel_orders[j]:
		r := x[j] mod RelativeOrders(DTObj)[j];
		q := (x[j] - r)/RelativeOrders(DTObj)[j];
		
		# In the following, compute w = w1 * w2, where
		# w1 = ( a_j^rel_orders[j] )^q 
		#		 = ( a_{j + 1}^{c_{j, j, j + 1}} ... a_n^{c_{j, j, n}} )^q 
		# and
		# w2 = a_{j + 1}^{x_{j + 1}} ... a_n^{x_n}
		# Then w only depends on the generators a_{j + 1}, ..., a_n and
		# its normal form can be computed (recursively). 
		
		pwr := GetPower(DTObj, j); 
		# z = a_{j + 1}^c_{j, j, j + 1} ... a_n^{c_{j, j, n}}
		z := [1 .. n] * 0; 
		for k in [1, 3 .. (Length(pwr) - 1)] do 
			z[pwr[k]] := pwr[k + 1];
		od; 

		# Compute w1 = z^q
		w1 := DTP_Exp(z, q, DTObj);

		# w2 = a_{j + 1}^{x_{j + 1}} ... a_n^{x_n}
		w2 := [1 .. j] * 0; # [0, ..., 0] of length j
		for i in [(j + 1) .. n] do
			Add(w2, x[i]); 
		od;
		
		# w = w1 * w2 
		w := multiply(w1, w2, DTObj); 
		
		# At this point, nf is a list describing the beginning of the 
		# exponent vector of the normal form of x. If some relative orders 
		# are infinite, the corresponding exponents in x are simply added, 
		# and lastly the exponent r of the generator a_j is added. Afterwards,
		# nf is a list of length j, which must be completed in the following
		# recursion steps, in which the normal form of "the rest" w" of x is 
		# computed. 
		for i in [(Length(nf) + 1) .. (j - 1)] do 
			Add(nf, x[i]);
		od;
		Add(nf, r); # j-th entry 

		return _DTP_DetermineNormalForm(w, DTObj, nf, multiply);
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
#			- DTObj
# Output: 	exponent vector of normal form of x  
InstallGlobalFunction( DTP_NormalForm, 
function(x, DTObj)
	local multiply; 
	
	multiply := DTP_DetermineMultiplicationFunction(DTObj); 
	
	return _DTP_DetermineNormalForm(x, DTObj, [], multiply);
end );


# Input: 	pcp element
# Output: 	pcp element in normal form 
InstallGlobalFunction( DTP_PCP_NormalForm, 
function(pcp)
	local dtobj; 
	
	dtobj := Collector(pcp);
	
	if not IsDTObj(dtobj) then 
		Error("Collector(pcp) must be a DTObj");
	elif not dtobj![PC_DTPConfluent] = true then 
		Error("collector must be confluent"); 
	else
		return PcpElementByExponentsNC(dtobj, DTP_NormalForm(Exponents(pcp), dtobj)); 
	fi; 
	
end );

# Input:	- exponent vector x (must describe a normal form)
#			- DTObj
# Output: 	order of x in group of coll 
_DTP_DetermineOrder := function(x, DTObj, multiply)
	local j, s, ord; 
	ord := 1; 
	# DTObj![PC_DTPPolynomials] = DTpols(coll)
	
	while x <> [1 .. DTObj![PC_NUMBER_OF_GENERATORS]] * 0 do
		j := 1;
		while x[j] = 0 do
			j := j + 1; # exists, since x <> neutral element
		od; 
		if RelativeOrders(DTObj)[j] = 0 then # relative order s_j = infinity 
			return infinity;
		else
			# s = s_j/gcd(s_j, x_j) 
			s := RelativeOrders(DTObj)[j]/Gcd(RelativeOrders(DTObj)[j], x[j]); 
			
			# ord(x) = infinity <=> ord(x^s) = infinity
			# ord(x) < infinity => s | ord(x)
			
			# Compute y = x^s:
			x := DTP_Exp(x, s, DTObj); 
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
#			- DTObj
# Output: 	order of x in group of coll 
InstallGlobalFunction( DTP_Order, 
function(x, DTObj)
	local multiply; 
	
	multiply := DTP_DetermineMultiplicationFunction(DTObj); 

	# check whether x is in normal form, if not call _DTP_DetermineNormalForm
	# DTP_IsInNormalForm returns true or an intger, if not in normal form
	if DTP_IsInNormalForm(x, DTObj) <> true then  
		x := _DTP_DetermineNormalForm(x, DTObj, [], multiply); 
	fi; 
	
	return _DTP_DetermineOrder(x, DTObj, multiply);
end );

# Input: 	pcp element
# Output: 	order of pcp 
InstallGlobalFunction( DTP_PCP_Order, 
function(pcp)
	local dtobj; 
	
	dtobj := Collector(pcp);
	
	if not IsDTObj(dtobj) then 
		Error("Collector(pcp) must be a DTObj");
	elif not dtobj![PC_DTPConfluent] = true then 
		Error("collector must be confluent"); 
	else
		return DTP_Order(Exponents(pcp), dtobj); 
	fi; 
	
end );
