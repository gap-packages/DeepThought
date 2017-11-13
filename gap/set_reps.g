# This file contains the function:
#	DTP_ComputeSetReps
##############################################################################

# Input: 	- collector coll 
#			- 0 <= s <= coll![PC_NUMBER_OF_GENERATORS] =: n
# Output:	A list reps of length n. 
#			If s = 0, then reps[r] describes the set reps_r.
#			Otherwise reps[r] describes the set reps_rs for this value of s.
DTP_ComputeSetReps := function(coll, s)
	local reps, n, r, i, j, cnj, alpha, beta, pair, gamma, delta, l, epsilon; 
	
	# If s = 0, then reps = [reps_1, ..., reps_n].
	# Otherwise reps = [reps_1s, ..., reps_ns] 
	reps := []; 
	
	n := coll![PC_NUMBER_OF_GENERATORS]; # number n of generators (a_r)
	Assert(1, s <= n); 
	
	# [PC_CONJUGATES][j][i] is a list describing the conjugate relation for
	# i < j, i.e. if c := [PC_CONJUGATES][j][i], then: 
	# a_j^a_i = a_i^{-1} a_j a_i = a_c[1]^c[2] * a_c[3]^c[4] * ... 
	
	# Initialize the sets reps with atom representatives.
	# Indeed, we do not store letters in the sets reps_r(s), but the output 
	# of the function DTP_StructureLetter for a letter, in order to compute 
	# structural information only once for each letter. 
	# 
	# Depending on whether reps_r or reps_rs shall be computed, the 
	# initialization differs:
	if s = 0 then # initalization for computing the sets reps_r 
		for r in [1 .. n] do 
			reps[r] := [DTP_StructureLetter(rec( num := r, pos := 1, side := DT_left, l := 1)), 
			DTP_StructureLetter(rec( num := r, pos := 1, side := DT_right, l := 1)) ];
		od; 
	else # initalization for computing the sets reps_rs 
		for r in [1 .. n] do
			if r = s then
				reps[r] := [DTP_StructureLetter(rec( num := r, pos := 1, side := DT_left, l := 1)), 
				DTP_StructureLetter(rec( num := r, pos := 1, side := DT_right, l := 1)) ];
			else
				reps[r] := [DTP_StructureLetter(rec( num := r, pos := 1, side := DT_left, l := 1))];
			fi; 
		od; 
	fi; 
	
	# find non-atom representatives 
	for r in [3 .. n] do
		for i in [1 .. (r - 2)] do
			for j in [(i + 1) .. (r - 1)] do 
				# determine representatives for all letters which may occur 
				# when a_j a_i is collected 
				
				# If coll![PC_CONJUGATES][j][i] is not bound, then the 
				# generators a_j and a_i commute and we have 
				# 	c_{i, j, j + 1} = ... = c_{i, j, n} = 0, 
				# hence the condition in line 5 of Algorithm "DTP_ComputeSetReps" 
				# (p. 28) is not fulfilled and there's nothing to do for 
				# this pair (i, j)
				if IsBound(coll![PC_CONJUGATES][j][i]) then 
					cnj := coll![PC_CONJUGATES][j][i]; 
					# Since IsBound() above is true, we must have 
					# Length(cnj) >= 3 and we may access this entry.
					# (This is because cnj = [j, 1, gen, e, ...] where the 
					# list contains at least one more generator gen with 
					# exponent e, since 
					#	IsBound( -as above- ) = false 
					#				<=> 
					#	cnj corresponds to [j, 1] 
					#				<=> 
					#		a_j a_i = a_i a_j.)
					if cnj[3] = r then 
						for alpha in reps[i] do
							for beta in reps[j] do
								for epsilon in DTP_Least(alpha, beta, coll) do
									if DTP_LeftOf(epsilon[3].left, epsilon[3].right) then 
										for l in [3, 5 .. (Length(cnj) - 1)] do 
											# Now we add a representative 
											# with num value cnj[l] to reps. 
											# This representative is almost 
											# identical to epsilon, only the 
											# num value of the letter itself
											# needs to be changed and added 
											# to the representative list. 
											# So, we add something of the 
											# following structure to reps, 
											# where we make copies of the 
											# 1. and 3. component since we 
											# need to vary them. Structure:
											# [classes_reps, classes_size, 
											# 			alpha, classes_elms]
											
											Add(reps[cnj[l]], [ShallowCopy(epsilon[1]), epsilon[2], ShallowCopy(epsilon[3]), epsilon[4]]);
											
											# change num value of letter
											reps[cnj[l]][Length(reps[cnj[l]])][3].num := cnj[l]; 
											# add letter to its 
											# representative list
											Add(reps[cnj[l]][Length(reps[cnj[l]])][1], reps[cnj[l]][Length(reps[cnj[l]])][3]);  
											
											# Now the added representative
											# has the same content as when 
											# calling DTP_StructureLetter with 
											# input letter as below: 
											# !! This assertion only holds if 
											# letter1left = true in 
											# DTP_StructureLetterFromExisting !!
											Assert(	5, 
													reps[cnj[l]][ Length( reps[cnj[l]] )] = 
													DTP_StructureLetter(rec( 	left := epsilon[3].left, 
																			right := epsilon[3].right, 
																			num := cnj[l], 
																			pos := 1, 
																			l := epsilon[3].left.l + epsilon[3].right.l + 1)),
													Error("This assertion only holds if letter1left = true in DTP_StructureLetterFromExisting. Change 'if left.l < right.l then' to 'if true then' to test this assertion,") ); 
											
											# TODO Try to compute the
											# polynomials simultaneously and 
											# use this in order to evaluate 
											# polynomials g_alpha which 
											# differ only in their num value
											# only once.
											# (Remark that they belong to 
											# different polynomials!). At
											# least for "ex14" this should
											# make a time difference when 
											# multiplying, since for this 
											# group the list 
											# [3, 5, .. (Length(cnj) - 1)] 
											# contains often more than 1 
											# entry (up to 17). 
										od; 
									fi; 
								od; 
							od;
						od;
					fi;
				fi; 
			od; 
		od; 
	od;
	
	return reps; 
end;