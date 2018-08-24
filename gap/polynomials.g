# This file contains the functions:
#	DTP_DTpols_rs
#	DTP_DTpols_r_S
#
#	DTP_DTpols_r
#
#	DTP_Polynomial_g_alpha
#	DTP_ReducePolynomialsModOrder
#	DTP_OrdersGenerators
#	DTP_FinalizeDTObj
#
# 	DTP_DTObjFromCollector
#############################################################################

# Input: 	- letter alpha
#			- collector coll
# Output: 	list g_alpha representing the polynomial g_alpha in the
#			following form:
# By definition, g_alpha is the product of certain binomial coefficients:
#		 g_\alpha = \prod_{A in Sub(\alpha)}/ ~~ \binom{T_A}{|A|}
# These binomial coefficients are stored in a list g_alpha.
# The first entry g_alpha[1] denotes a constant factor (which
# comes from the binomial coefficients when the indeterminate
# T_A is C_{i,j,k} and we directly replace the conjugacy coefficients).
# All other entries g_alpha[2], ..., g_alpha[k] describe binomial
# coefficients Binom(a, b), where an entry is a pair of natural
# numbers [var, size] such that:
# 	- "var" in [1 .. 2n] denotes the indeterminate, where we use
#	the correspondence 	1 <-> X_1, ..., n <-> X_n
#						n + 1 <-> Y_1, ..., 2n <-> Y_n
#	- "size" is "b" in the binomial coefficient
DTP_Polynomial_g_alpha := function(alpha, coll)
	local g_alpha, classes_reps, classes_size, i, rep, cnj, j, n, monomial;

	n := coll![PC_NUMBER_OF_GENERATORS];

	g_alpha := [];
	# When the indeterminate T_A in the factor Binom(T_A, |A|) of
	# g_alpha equals C_{i,j,k}, the binomial coefficient is evaluated
	# directly and g_alpha[1] stores the product of all these values.
	g_alpha[1] := 1; # neutral element of multiplication
	# If the indeterminate T_A corresponds to X_r (<-> r) or Y_r (<-> n + r),
	# then we store the binomial coefficient [T_A, |A|] in the list
	# monomial. Before appending monomial to g_alpha we sort
	# the list monomial due to the indeterminates 1, ..., 2n in the
	# first entry of the binomial coefficients (to ease comparision)
	monomial := [];

	# for computing g_alpha, representatives of the equivalence classes
	# of Sub(alpha[3]) and the class sizes are needed:
	classes_reps := alpha[1];
	classes_size := alpha[2];

	i := 1; # position of current "rep" in list alpha_classes_reps
	for rep in classes_reps do # Loop over all representative letters..
		Assert(1, classes_size[i] > 0); # |A| > 0
		if IsBound(rep.side) then # If rep is an atom:
			if rep.side = DT_left then # ..and it comes from the left side,
				# then add the binomial coefficient for the indeterminate
				# rep.num <-> X_{rep.num}
				Add(monomial, [rep.num, classes_size[i]]);
			else # ..and if it comes from the right side,
				# then add the binomial coefficient for the indeterminate
				# n + rep.num <-> Y_{rep.num}
				Add(monomial, [n + rep.num, classes_size[i]]);
			fi;
		else # If rep is a non-atom:
			# ..evaluate the factor Binom(T_A, |A|) directly and multiply
			# the first entry of g_alpha by this factor. By definition,
			# T_A = T_rep = C_{num(rep.right), num(rep.left), num(rep)}.
			# Find coefficent c_{num(rep.right), num(rep.left), num(rep)}:
			cnj := coll![PC_CONJUGATES][rep.left.num][rep.right.num];
			for j in [1, 3 .. (Length(cnj) - 1)] do
				# The numbers corresponding to generators are stored in the
				# uneven entries of cnj. rep.num must occur in cnj[2N+1]
				# since it has to occur with non-zero exponent (else we
				# would not have come to this point by construction of
				# DTP_ComputeSetReps_r(s)).
				if cnj[j] = rep.num then
 					g_alpha[1] := g_alpha[1] * Binomial(cnj[j + 1], classes_size[i]);
					break;
				fi;
			od;
		fi;
		i := i + 1;
	od;

	SortBy(monomial, function(v) return v[1]; end);
	Append(g_alpha, monomial);

	Assert(1, g_alpha[1] <> 0); # since criterion g_alpha = 0 is used
	# when computing the set Least, see function DTP_FindCoefficient

	return g_alpha;
end;

# Reduce the polynomials "pols" (corresponding to the pols
# [f_1, ..., f_n] or [f_1,s, ..., f_n,s] for a fixed s) modulo the generator
# orders.
DTP_ReducePolynomialsModOrder := function(pols, orders)
	local r, i;

	for r in [1 .. Length(pols)] do # polynomial f_r or f_r,s
		for i in Reversed([1 .. Length(pols[r])]) do # all summands
			if orders[r] < infinity then
				# pols[r] = polynomial f_r or f_r, s for a fixed s.
				# pols[r][i] = g_alpha for a letter alpha.
				pols[r][i][1] := pols[r][i][1] mod orders[r];
				# if the constant coefficient is now equal to zero, delete
				# the term:
				if pols[r][i][1] = 0 then
					Remove(pols[r], i);
				fi;
			fi;
		od;
	od;

end;

# Input:	DTObj where the "orders" are set to infinity
# Output:	none, but the orders for DTObj are computed and stored in the
#			third entry.
DTP_OrdersGenerators := function(DTObj)
	local s, n, gen;

	n := DTObj![PC_NUMBER_OF_GENERATORS];

	for s in [1 .. n] do
		gen := [1 .. n] * 0;
		gen[s] := 1;
		DTObj![32][s] := DTP_Order(gen, DTObj);
	od;

end;

# Creates a DTObj = [] for a collector coll with polynomials pols
# and flag isConfl.
DTP_FinalizeDTObj := function(DTObj, coll, pols, isConfl)
	local r, n;

	n := coll![PC_NUMBER_OF_GENERATORS];
	# Compute the orders of the generators and reduce the polynomials modulo
	# the generator orders. This is not possible if the collector is not
	# consistent and thus isConfl = false.
	for r in [1..30] do
		if IsBound(coll![r]) then
			DTObj[r] := StructuralCopy(coll![r]);
		fi;
	od;

	DTObj[PC_DTPPolynomials] := pols;
	DTObj[PC_DTPOrders] := [1 .. n] * infinity; # for computing the generator
	# orders we also need to provide "orders", since we use the same
	# functions for multiplication. Hence, first assume them to be infinite.

	DTObj[33] := isConfl;
	Objectify(DTObjType, DTObj);

	if isConfl then
		# called by DTP_DTpols_r
		if IsInt(pols[1][1][1]) then
			DTP_OrdersGenerators(DTObj);
			DTP_ReducePolynomialsModOrder(DTObj![31], DTObj![32]);
		else # called by DTP_DTpols_rs
			DTP_OrdersGenerators(DTObj);
			for r in [1 .. n] do
				DTP_ReducePolynomialsModOrder(DTObj![31][r], DTObj![32]);
			od;
		fi;
	else
		# We will use the same function for multiplication as
		# in the case, when the generator orders are provided. The generator
		# orders are, if finite, used for reduction modulo the orders during
		# computations. Hence, if we set each generator order to be infinity,
		# this yields the same result as doing no reduction, since in
		# Muliply_s we always execute the "else" statement.
	fi;

	return DTObj;
end;

#############################################################################
####					Polynomials f_rs								 ####
#############################################################################

# Input:	- collector coll
#			- number s with s <= coll![PC_NUMBER_OF_GENERATORS]
# Output: 	pols_f_rs is a list of the polynomials f_rs, 1 <= r <= n. By
#			definition:
#			f_rs = \sum_{\alpha in reps_rs} g_\alpha
# 			An entry pols_f_rs[r] contains lists as described in g_alpha
#			which represent the summands of f_rs.
DTP_DTpols_r_S := function(coll, s)
	local n, pols_f_rs, reps, r, f_rs, reps_rs, alpha, g_alpha, term, added;

	n := coll![PC_NUMBER_OF_GENERATORS];
	Assert(1, s <= n);

	pols_f_rs := [];
	# compute reps_rs for 1 <= r <= n
	reps := DTP_ComputeSetReps(coll, s);
	for r in [1 .. n] do
		# compute polynomial f_rs: f_rs is list of summands
		# g_alpha as described in DTP_Polynomial_g_alpha
		f_rs := [];
		reps_rs := reps[r]; # = reps_rs
		for alpha in reps_rs do # for every representative in reps_rs
		# compute the polynomial g_alpha
			# Check whether g_alpha is already contained in f_rs.
			# If yes, add the constant factor of g_alpha to the
			# constant factor of term which is already contained.
			#
			# Notice that we may simplify terms if they only differ
			# in their leading coefficient and we may compare polynomials
			# g_alpha as done below since the entries are sorted by
			# construction of g_alpha.
			g_alpha := DTP_Polynomial_g_alpha(alpha, coll);
			added := false;
			for term in [1 .. Length(f_rs)] do
				if Length(f_rs[term]) = Length(g_alpha) and f_rs[term]{[2 .. Length(f_rs[term])]} = g_alpha{[2 .. Length(g_alpha)]} then
					f_rs[term][1] := f_rs[term][1] + g_alpha[1];
					added := true;
					if f_rs[term][1] = 0 then
						Remove(f_rs, term);
					fi;
					break;
				fi;
			od;
			if not added then
				Add(f_rs, g_alpha);
			fi;
		od;

		# add polynomial f_rs to list pols_f_rs
		Add(pols_f_rs, f_rs);
	od;


	return pols_f_rs;
end;

# Input:	- collector coll
#			- "isConfl" must be a boolean value.
#			If isConfl = false, then the collector is
#			supposed to be not consistent. When using the returned DTObj for
#			multiplication, the results are returned as reduced words which
#			are not necessarily in normal form. If isConlf = true, the
#			collector is assumed to be consistent.
# Output:	object DTObj, where the second entry contains a list
#			all_pols such that DTP_DTpols_rs[s] is the output of
#			DTP_DTpols_r_S(coll, s)
DTP_DTpols_rs := function(coll, isConfl)
	local n, s, all_pols, orders, gen;

	n := coll![PC_NUMBER_OF_GENERATORS];

	all_pols := [];
	# for every 1 <= s <= n compute the polynomials f_rs, 1 <= r <= n
	for s in [1 .. n] do
		Add(all_pols, DTP_DTpols_r_S(coll, s));
	od;

	# create DTObj:
	return DTP_FinalizeDTObj([], coll, all_pols, isConfl);
end;

#############################################################################
####					Polynomials f_r									 ####
#############################################################################

# Input:	- collector coll
#			- "isConfl" must be a boolean value.
#			If isConfl = false, then the collector is
#			supposed to be not consistent. When using the returned DTObj for
#			multiplication, the results are returned as reduced words which
#			are not necessarily in normal form. If isConlf = true, the
#			collector is assumed to be consistent.
# Output:	object DTObj such that the second entry "pols_f_r" is a list of
# 			the polynomials f_r, 1 <= r <= n. By definition:
#				f_r = \sum_{\alpha in reps_r} g_\alpha
# 			An entry pols_f_r[r] contains lists as described in g_alpha
#			which represent the summands of f_r.
DTP_DTpols_r := function(coll, isConfl)
	local n, pols_f_r, reps, r, f_r, reps_r, alpha, g_alpha, term, added;

	n := coll![PC_NUMBER_OF_GENERATORS];
	pols_f_r := [];
	# compute reps_r for 1 <= r <= n
	reps := DTP_ComputeSetReps(coll, 0);

	# compute the polynomials
	for r in [1 .. n] do
		# compute polynomial f_r: f_r is list of summands
		# g_alpha as described in DTP_Polynomial_g_alpha
		f_r := [];
		reps_r := reps[r]; # = reps_r
		for alpha in reps_r do # for every representative in
		# reps_r compute the polynomial g_alpha
			# Check whether g_alpha is already contained in f_r.
			# If yes, add the constant factor of g_alpha to the
			# constant factor of term which is already contained.
			#
			# Note that we may simplify terms if they only differ
			# in their leading coefficient and we may compare polynomials
			# g_alpha by using
			#	"g_alpha1{[2 .. Length(g_alpha1)]} =
			#							g_alpha2{[2 .. Length(g_alpha2)]}"
			# since the entries are sorted by construction of g_alpha.
			g_alpha := DTP_Polynomial_g_alpha(alpha, coll);
			added := false;
			for term in [1 .. Length(f_r)] do
				if Length(f_r[term]) = Length(g_alpha) and f_r[term]{[2 .. Length(f_r[term])]} = g_alpha{[2 .. Length(g_alpha)]} then
					f_r[term][1] := f_r[term][1] + g_alpha[1];
					added := true;
					if f_r[term][1] = 0 then
						Remove(f_r, term);
					fi;
					break;
				fi;
			od;
			if not added then
				Add(f_r, g_alpha);
			fi;
		od;
		# add polynomial f_r to list pols_f_r
		Add(pols_f_r, f_r);
	od;

	# create DTObj:
	return DTP_FinalizeDTObj([], coll, pols_f_r, isConfl);
end;

#############################################################################
####					Computing a DTObj								 ####
#############################################################################

# Input: 	- collector coll
#			- optional boolean rs_flag: if rs_flag = true, polynomials f_rs
#			will be computed, otherwise polynomials f_r. If not provided,
#			by default the polynomials f_rs will be computed.
# Output:	If rs_flag = true or not provided, the function DTP_DTpols_rs is
#			called and its output returned. Otherwise the function
#			DTP_DTpols_r is called and its output returned.
InstallGlobalFunction( DTP_DTObjFromCollector,
function(coll, rs_flag...)
	local isConfl;

	isConfl := IsConfluent(coll);

	if not isConfl then
		Print("Note that the collector is not confluent.\n");
	fi;

	if Length(rs_flag) = 0 then
		# If the optional argument is not given, compute f_rs
		return DTP_DTpols_rs(coll, isConfl);
	elif Length(rs_flag) = 1 and IsBool(rs_flag[1]) then
		if rs_flag[1] = true then
			return DTP_DTpols_rs(coll, isConfl);
		elif rs_flag[1] = false then
			return DTP_DTpols_r(coll, isConfl);
		fi;
	else
		Error("the optional argument rs_flag has to be a boolean value"); 
	fi;

end );
