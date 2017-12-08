# If DTP_DecisionCriterion(coll) = true, then there occurs a letter which 
# leads to a polynomial g_alpha = Y_i Y_l * terms with i <> l. This 
# letter would not occur in any set reps_rs. Hence, when using the 
# polynomials f_rs we would never need to evaluate this polynomial. 
# This suggests the following rule: 
#	true => use polynomials f_rs 
#	false => use polynomials f_r
DTP_DecisionCriterion := function(coll)
	local n, i, j, k, l, m, a, b, cnj_ijk, cnj_lkm; 
	
	n := NumberOfGenerators(coll); 
	for i in [1 .. n] do 
		for j in [(i + 1) .. n] do 
			cnj_ijk := GetConjugate(coll, j, i); 
			for a in [3, 5 .. (Length(cnj_ijk) - 1)] do 
				k := cnj_ijk[a]; # Generator with index k introduced when a_j
				# and a_i are interchanged. 
				if cnj_ijk[a + 1] <> 0 then 
				# Introduce a_k^exp with exp <> 0?
					for l in [(i + 1) .. (k - 1)] do 
						if i <> l then 
							cnj_lkm := GetConjugate(coll, k, l); 
							for b in [3, 5 .. (Length(cnj_lkm) - 1)] do
#								m := cnj_lkm[b]; 
								if cnj_lkm[b + 1] <> 0 then # superfluent? 
									return true; 
								fi;
							od;
						fi;
					od;
				fi;
			od;
		od;
	od;
	
	return false; 
end;

# checks conjugacy relations of coll, must be of the form 
# 	a_i^{-1} a_j a_i = a_j a_{j + 1}^{c_{i, j, j + 1}} ... a_n^{c_{i, j, n}} 
# 	(<=> a_j a_i = a_i a_j a_{j + 1}^{c_{i, j, j + 1}} ... a_n^{c_{i, j, n}})
DTP_CheckCnjRels := function(coll)
	local n, i, j, cnj, len, k; 
	
	n := coll![PC_NUMBER_OF_GENERATORS];
	
	# check the conjugate relations: 
	for i in [1 .. (n - 1)] do
		for j in [(i + 1) .. n] do
			# If c := GetConjugate(coll, j, i), then 
			# a_j^a_i = a_i^{-1} a_j a_i = a_c[1]^c[2] * a_c[3]^c[4] * ... 
			if IsBound(coll![PC_CONJUGATES][j][i]) then
				cnj := coll![PC_CONJUGATES][j][i];
				len := Length(cnj);
				# len should never be 0, check anyway. cnj[1] must be generator
				# j and its exponente must be 1
				if len = 0 or cnj[1] <> j or cnj[2] <> 1 then
					return false;
				else # now cnj[1] = j with exponent 1 
					for k in [1, 3 .. (len - 3)] do
						# the indices of the following generators must increase
						if cnj[k] >= cnj[k + 2] then
							return false;
						fi; 
					od;
				fi; 
#			else-case:
				# If IsBound(coll![PC_CONJUGATES][j][i]) returns false, then
				# the conjugate relation is trivial, i.e. a_j^a_i = a_j, and
				# the relation is of the needed form. 
			fi;
		od;
	od;

	return true; 
end;

# checks power relations of coll, must be of the form 
# a_r^s_r = a_{r + 1}^{c_{r, r, r + 1}} ... a_n^{c_{r, r, n}}
DTP_CheckPwrRels := function(coll)
	local n, r, coeff, j; 
	
	n := coll![PC_NUMBER_OF_GENERATORS];
	for r in [1 .. n] do
		# coeff is power relation for generator r
		coeff := GetPower(coll, r); 
		# coeff is a list [a_{i_1}, r_{i_1}, ..., a_{i_m], r_{i_m}] 
		# representing the power relation
		#	a_r^{relative order} = a_{i_1}^{r_{i_1}} ... a_{i_m}^{r_{i_m}}
		# It may also be an empty list, which also describes a valid
		# power relation. 
		#
		# In the above notation we need i_1 < ... < i_m and i_1 > r:
		if Length(coeff) > 0 and coeff[1] <= r then
			return false;
		fi;
		for j in [1, 3 .. (Length(coeff) - 3)] do
			if coeff[j] >= coeff[j + 2] then
				return false; 
			fi; 
		od;
	od;
	
	return true; 
end;

# Check collector coll for applicability of DT functions. 
# Notice that depending on consistency some functions may be applicable
# and some not. The result is printed to terminal. "+" means that the 
# following property is fulfilled, otherwise there is a "-". 
# The function returns "false" if Deep Thought is not applicable to the 
# collector coll and "true" otherwise. Anyway, even if "true" is returned, 
# NOT ALL FUNCTIONS MAY BE APPLICABLE (in case of inconsistenies). 
# Further information is printed to the terminal. 
InstallGlobalFunction( DTP_DTapplicability, 
function(coll)
	
	Print("Checking collector for DT-applicability. \"+\" means the following property is fulfilled.\n"); 
	
	# Check form of conjugacy relations in the collector.
	if DTP_CheckCnjRels(coll) then 
		Print("+   conjugacy relations\n"); 
	else
		Print("The conjugacy relations are NOT fulfilled. DT is NOT applicable.\n"); 
		return false; 
	fi; 
	
	# Check form of power relations in the collector.
	# Needed for: 
	#	- order
	#	- normal form 
	if DTP_CheckPwrRels(coll) then 
		Print("+   power relations\n"); 
	else
		Print("-   power relations - you may get wrong results when using \"DTP_NormalForm\", and \"DTP_Order\" may not terminate. \n"); 
	fi; 
	
	# Check consistency of the collector.
	# Needed for: 
	#	- order
	#	- normal form 
	if IsConfluent(coll) then 
		Print("+   confluent\n"); 
	else
		Print("-   confluent: you may get wrong results when using \"DTP_NormalForm\", and \"DTP_Order\" may not terminate. \n"); 
	fi; 
	
	# Recommend which polynomials one should use for this collector 
	if DTP_DecisionCriterion(coll) then 
		Print("Suggestion: Call DTP_DTObjFromColl with rs_flag = true.\n"); 
	else 
		Print("Suggestion: Call DTP_DTObjFromColl with rs_flag = false.\n"); 
	fi; 
	
	return true; 
end);  
