# This file contains the function:
#	DTP_ComputeSetReps
##############################################################################

# Input: 	- number n
#			- 0 <= s <= coll![PC_NUMBER_OF_GENERATORS] =: n
# Output:	A list reps of length n.
#		   reps[r] describes the set reps_rs for this value of s.
DTP_ComputeSetReps := function(n, s)
	local reps, r, i, j, cnj, alpha, beta, pair, gamma, delta, k, epsilon;

  reps := [];

	Assert(1, s <= n);

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
        j := r - 1; # c_{i, j, j+1} <> 0
				# determine representatives for all letters which may occur
				# when a_j a_i is collected
				for alpha in reps[i] do
					for beta in reps[j] do
						for epsilon in DTP_Least(alpha, beta) do
							if DTP_LeftOf(epsilon[3].left, epsilon[3].right) then
								for k in [r .. n] do # c_{i,j,k} <> 0 for all i, j, k
									# Now we add a representative
									# with num value k to reps.
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

									Add(reps[k], [ShallowCopy(epsilon[1]), epsilon[2], ShallowCopy(epsilon[3]), epsilon[4]]);

									# change num value of letter
									reps[k][Length(reps[k])][3].num := k;
									# add letter to its
									# representative list
									Add(reps[k][Length(reps[k])][1], reps[k][Length(reps[k])][3]);

									# Now the added representative
									# has the same content as when
									# calling DTP_StructureLetter with
									# input letter as below:
									# !! This assertion only holds if
									# letter1left = true in
									# DTP_StructureLetterFromExisting !!
									Assert(	5,
											reps[k][ Length( reps[k] )] =
											DTP_StructureLetter(rec( 	left := epsilon[3].left,
																	right := epsilon[3].right,
																	num := k,
																	pos := 1,
																	l := epsilon[3].left.l + epsilon[3].right.l + 1)),
											Error("This assertion only holds if letter1left = true in DTP_StructureLetterFromExisting. Change 'if left.l < right.l then' to 'if true then' to test this assertion,") );
								od;
							fi;
						od;
					od;
				od;
			od;
	od;

	return reps;
end;
