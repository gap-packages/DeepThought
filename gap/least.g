# This file contains the functions:
#	DTP_CreateSimLetter
#	DTP_NumberHSS
#	DTP_FindCoefficient
#	DTP_SimilarLetters
#	DTP_Least
#############################################################################

# check whether a letter is least in its ~-class
# Input: 	letter alpha
# Output:	true, if alpha is least in its class; false, otherwise
DTP_IsLeastLetter := function(alpha)
	local classes_reps, lists_prop235, j, i, subletter; 
	
	classes_reps := alpha[1]; 
	# lists_prop235 contains one list for each almost-equality-class of
	# Sub(alpha). In each such list l, l[i] = 1 if there exists a 
	# subletter in this class with position = i. Otherwise this entry
	# is unbound. 
	lists_prop235 := [];
	for j in [1 .. Length(classes_reps)] do 
		Add(lists_prop235, []); 
	od; 
	
	for i in [1 .. alpha[3].l] do # length of letter alpha
		subletter := DTP_Seq_i(alpha[3], i); # go through all subletters
		for j in [1 .. Length(classes_reps)] do  
			# search for representative of subletters' class. 
			if DTP_AreAlmostEqual(classes_reps[j], subletter) then 
				lists_prop235[j][subletter.pos] := 1; 
				# found a subletter with position value
				# subletter.pos of the class of representative nr. j, 
				# i.e. mark in the j-th list this position
			fi;
		od; 
	od; 
	
	return ForAll(lists_prop235, i -> IsDenseList(i)); 
end;  

# Input: 	- a least letter alpha
#			- tuple of tuples "tuples" (suitable for alpha) as computed in 
#			"DTP_SimilarLetters"
# Output:	none, but the pos-values of alpha's subletters are manipulated 
#			due to "tuples". I.e.: If the subletter Seq(alpha, j) has 
#			position p and is almost equal to the representative alpha[1][i],
#			then its position is set to tuples[i][p]. 
DTP_CreateSimLetter := function(alpha, tuples)
	local i, class_rep, j, subletter;  
	
	Assert(1, DTP_IsLeastLetter(alpha));

	for i in [1 .. Length(alpha[1])] do # for each representative 
		class_rep := alpha[4][i]; # get class of representative
		for j in class_rep do # for each class member
			subletter := DTP_Seq_i(alpha[3], j); # get class member
			subletter.pos := tuples[i][subletter.pos]; 
		od; 
	od; 
	
end; 

# Determines the number of subletters of "letter" which have the same 
# structure as the letter rep.
DTP_NumberHSS := function(rep, letter)
	local num, i, class, subletter;  
	
	class := [];
	num := 0; 
	for i in [1 .. letter.l] do 
		subletter := DTP_Seq_i(letter, i); 
		if DTP_HaveSameStructure(subletter, rep) then 
			if not subletter in class then
				Add(class, subletter); 
				num := num + 1;
			fi; 
		fi;
	od; 
	
	return num; 
end; 

# Used to apply criterion g_alpha = 0 
# Applying this is really essential when computing the polynomials
# for ex14. Without: 12 min 	With: 	53 sec
# Input: 	letter rep and collector coll
# Output:	a positive integer or infinity. If rep is an atom, infinity is
#			returned. Otherwise the coefficient c_{i, j, k} is computed with 
#			which "rep" was introduced, the conjugate coefficient c_{i, j, k} 
#			with rep.left.num = i, rep.right.num = j and rep.num = k. 
#			If this coefficient is positive, the coefficient is returned, 
#			otherwise the return value is infinity. 
DTP_FindCoefficient := function(rep, coll)
	local max, cnj, i; 
	
	# If letters of current class are non-atoms, find upper bound for 
	# pos-entries, i.e. the conjugate coefficient. For atoms there's no 
	# such bound since the exponents of input words are unbounded. 
	# (see p. 31)
	max := infinity; # upper bound for pos-entries 
	if IsBound(rep.left) then # non-atom condition
		# Get conjugate relation with which the generator labelled by 
		# this letter was introduced and find exponent of generator 
		# rep.num in this relation:
		cnj := coll![PC_CONJUGATES][rep.left.num][rep.right.num];
		i := 1; 
		while cnj[i] < rep.num do
			i := i + 2;
		od;
		# By construction, the letter rep occurs
		# during the collection. It was constructed when its left and 
		# right part were interchanged. Hence, its num-value must occur 
		# in the coefficient list cnj (else the letter could not exist).
		# The entries corresponding to generators (i.e. at uneven 
		# positions) in cnj are strictly increasing by the input requirement
		# of the presentation. Thus, since num must be somewhere at an 
		# uneven position in cnj, after the preceding while-loop, num must 
		# be at position i in cnj. Then the corresponding coefficient is  
		# stored at position i + 1. If left.num = j and right.num = i, then 
		# this is the maximum value for the pos-value which a non-atom with 
		# left-part corresponding to generator a_j and right-part
		# corresponding to generator a_i and labelling itself a generator
		# a_num can have. 
		# (a_j a_i = a_i a_j a_cnj[1]^cnj[2] a_cnj[3]^cnj[4] ... )
		
		Assert(1, cnj[i] = rep.num); 
		
		# max can only be applied if coefficient is positive 
		if cnj[i + 1] >= 0 then 
			max := cnj[i + 1];
		fi; 
	fi;
	
	return max; 
end; 

# Input:	least letter alpha, its partner letter gamma
# Output: 	all letters similar to alpha with the 
#			restriction to pos values as explained in "DTP_Least" 
DTP_SimilarLetters := function(alpha, gamma, coll)
	local class, classes_reps, classes_size, T, s, tuples, sim_letter, num, coeff; 
	
	class := []; # sim-class of alpha with position restriction 
	classes_reps := alpha[1]; # representatives of alphas almost equality
	# classes 
	classes_size := alpha[2]; # sizes of alphas almost equality classes 
	
	# For each almost equality class of Sub(alpha) determine all tuples t 
	# of length = class size and 1 <= t[1] < ... < t[size] <= lim, where
	# lim is the "appropriate value" as explained in "DTP_Least". 
	# This corresponds to finding all subsets with "size" elements 
	# of the set {1, ..., lim}. Therefore we can use the GAP function 
	# "Combinations" 
	#
	# T[i] is a list containing all such tuples t for the class with 
	# representative classes_reps[i] and size classes_size[i].
	T := []; 
	for s in [1 .. Length(classes_size)] do
		# Length(alpha[4][s]) is the number of subletters of alpha which 
		# are almost equal to the current representative classes_reps[s]
		num := DTP_NumberHSS(classes_reps[s], gamma[3]) + Length(alpha[4][s]); 
		# Apply g_alpha = 0 criterion, i.e. take as upper bound the 
		# minimum of "num" and "coeff". 
		coeff := DTP_FindCoefficient(classes_reps[s], coll);
		if num < coeff then 
			Add(T, Combinations([1 .. num], classes_size[s])); 
		else 
			Add(T, Combinations([1 .. coeff], classes_size[s])); 
		fi; 
	od; 
	# TODO Above "Combinations" may be applied various times to the same 
	# values. Maybe first find for all representatives the arguments for the 
	# function Combinations and compute the results only once. On the other 
	# hand: the function seems to be really fast (at least for small values) 
	# such that it may make no difference?! See profiling. 
	
	# For each combination of such tuples we can build a new letter similar
	# to alpha. 
	for tuples in Cartesian(T) do 
		sim_letter := [alpha[1], alpha[2], StructuralCopy(alpha[3]), alpha[4]]; 
		DTP_CreateSimLetter(sim_letter, tuples);
		Add(class, sim_letter[3]); 
	od;
	
	return class; 
end; 

# Input: 	two least letters alpha, beta
# Output: 	list of all letters epsilon such that epsilon is least in its class, 
#			epsilon.left ~ beta, epsilon.right ~ alpha 
DTP_Least := function(alpha, beta, coll)
	local sim_alpha, sim_beta, pair, epsilon, least, i; 
	least := []; 
	
	# We need to compute all letters similar to alpha and beta and go through
	# them pairwise to construct new letters epsilon with the least property. 
	# Since there exist infinite many letters in a ~ class of a letter, we 
	# need to find a restriction when computing these setes. 
	# If gamma ~ alpha and delta ~ beta, then epsilon := [delta, gamma; 1_1] 
	# should be a least letter. Using Prop. we know that for least letters 
	# each almost equality class A of Sub(epsilon) must fulfil
	#	{pos(rho) | rho \in A} = {1, ..., |A|}, 
	# hence pos(rho) \in {1, ..., |A|}. 
	#
	# Since gamma ~ alpha, all corresponding subletters have the same 
	# structure. Hence, for each subletter rho of alpha we can compute how 
	# many (distinct) subletters of alpha plus how many (distinct) subletters
	# of beta exist with the same structure as rho,
	# and we can use this as an upper bound for the position values in rho: 
	# If A is the ~-class of (a maybe manipulated) rho as a subletter of 
	# epsilon, then 
	#	|A| = | {sigma \in Sub(epsilon) | sigma almost equal to rho} |
	#	<= | { sigma \in Sub(epsilon) | sigma has the same structure as rho} |
	#	<= | {sigma \in Sub(alpha) | sigma has the same structure as rho} | + 
	#	| {sigma \in Sub(beta) | sigma has the same structure as rho} |
	
	sim_alpha := DTP_SimilarLetters(alpha, beta, coll); 
	# Do the same for beta. 
	sim_beta := DTP_SimilarLetters(beta, alpha, coll); 
	 
	for pair in Cartesian(sim_alpha, sim_beta) do 
		epsilon := DTP_StructureLetterFromExisting(pair[2], beta[4], pair[1], alpha[4]); 
		if epsilon <> false then # If epsilon is a least letter,
			if not epsilon in least then # TODO This should always be 
			# fulfilled, then this if statement may be omitted. 
				Add(least, epsilon); # then add it to least. 
			fi; 
		fi; 
	od; 
	
	return least; 
end; 
