# This file contains the functions: 
#	DTP_StructureLetter
#	DTP_StructureLetterFromExisting
#############################################################################

# Input:	letter "letter"
# Output:	list containing the four components:
#			- list "classes_reps" with representative of each 
#			almost-equality-class of Sub(letter). Two distinct representatives
#			are in two different almost-equality-classes, i.e. there are no 
#			"duplicates" 
#			- list "classes_size" where classes_size[i] is the size of the
#			almost-equality-class of classes_reps[i]
#			- the letter "letter" itself
#			- list classes_elms, which contains itself lists [i_1, ..., i_k]
#			such that the subletters Seq(letter, i_1), ..., Seq(letter, i_k)
#			describe an almost equality class of Sub(letter)
DTP_StructureLetter := function(letter)
	local has_class, classes_reps, i, j, beta, classes_size, classes_elms, equiv_class, subletter, sequence; 
	
	has_class := []; # has_class stores positions of all letters in 
	# Seq(letter) that already have an equivalence class
	classes_reps := []; # set of representatives for every equivalence class
	classes_size := []; # sizes of equivalence classes 
	classes_elms := []; # classes_elms[k] is a list containing the numbers of 
	# subletters which are in the same class as classes_reps[k]
	equiv_class := []; # stores temporarily (set of) all letters of an almost
	# equalitiy class. More precisely, only the pos values are stored since 
	# almost equal letters only differ in their pos value. 
	sequence := []; 
	DTP_SequenceLetter(letter, sequence); 
	
	for i in [1 .. letter.l - 1] do # Take subletter Seq(letter, i) of letter,
		if not i in has_class then # if it has not yet a class, construct 
			# the equivalence class of this letter:
			beta := sequence[i]; # beta = Seq(letter, i)
			Add(classes_reps, beta); # beta is representative of its class
			equiv_class := [beta.pos]; # add beta to its class
			Add(has_class, i); # now beta has a class
			Add(classes_elms, [i]); 
			
			# Find all subletters which are in the same class as beta: 
			for j in [(i + 1) .. letter.l] do 
				# Find all subletters after beta in Seq(letter) which have 
				# not yet a class and are almost equal to beta.
				if not j in has_class then 
					subletter := sequence[j];
					if DTP_AreAlmostEqual(subletter, beta) then 
						if not subletter.pos in equiv_class then 
							# If the subletter is not contained in the "set"
							# equiv_class, add it (in order to determine the 
							# size of the equivalence class of beta).
							Add(equiv_class, subletter.pos);
						fi; 
						Add(has_class, j); # Now the subletter has a class. 
						Add(classes_elms[Length(classes_elms)], j); 
					fi;
				fi; 
			od; 
			
			# add size of equivalence class to list classes_size
			Add(classes_size, Length(equiv_class)); 
			 
		fi; 
	od;
	
	# The last subletter of letter is letter itself
	Add(classes_reps, letter); 
	Add(classes_size, 1); 
	Add(classes_elms, [letter.l]); 
	
	return [classes_reps, classes_size, letter, classes_elms]; 
end; 

# Input: 	- letters left and right
#			- corresponding lists classes_left and classes_right which 
#			contain lists [i_1, ..., i_l] such that the subletters 
#			Seq(left, i_1), ..., Seq(left, i_l) are in the same 
#			almost equality class of Sub(left). The same for "right". 
# Output:	- false, if the letter epsilon = [left, right; r_1] is not a 
#			least letter in its ~-class (r is an arbitrary positive integer)
#			- the same as if we would call DTP_StructureLetter with input
#			epsilon as above, BUT since the concrete value for "r" is left
#			open, the letter itself is missing in "classes_reps" (last entry
#			in this list) and the num-value is missing in "letter". That 
#			means, to become a "valid" output of DTP_StructureLetter, in the 
#			third list entry (which is the letter as a record) num component
#			for a concrete "r" must be added and afterwards this letter has 
#			to be added to the first list entry (which is the list of
#			representatives of almost equality classes of the letter). 
DTP_StructureLetterFromExisting := function(left, classes_left, right, classes_right)
	local letter1left, letter1, letter2, classes_letter1, classes_letter2, classes_reps, classes_size, classes_elms, has_class, i, class, rep, equiv_class, j, k, elms, sequence_letter2, found_letter2_class; 
	
	# Based on empirical results it seems to be a good idea to take the 
	# shorter of both letters as the letter we start with. 
	if left.l < right.l then 
		letter1left := true;  # letter1 = left
		letter1 := left; 
		classes_letter1 := classes_left; 
		letter2 := right;
		classes_letter2 := classes_right;
	else
		letter1left := false; # letter1 <> left
		letter1 := right;
		classes_letter1 := classes_right;
		letter2 := left; 
		classes_letter2 := classes_left; 
	fi; 
	
	classes_reps := []; 
	classes_size := []; 
	classes_elms := []; 
	
	has_class := []; 
	
	# The subletters of letter2 are needed quite often, so it makes sense to 
	# compute Seq(letter2) only once. In comparison, Seq(letter1) is needed 
	# only ~ letter1.l often. 
	sequence_letter2 := [];
	DTP_SequenceLetter(letter2, sequence_letter2); 
	
	# Go through all classes of letter1 and get representative and search for
	# almost equal subletters in letter2. If we find one, we have all thanks 
	# to classes_letter2 list.
	for i in [1 .. Length(classes_letter1)] do
		class := classes_letter1[i]; 
		rep := DTP_Seq_i(letter1, class[1]); # Let the first element from this 
		# class be the representative we are working with.
		Add(classes_reps, rep); 
		
		# Collect the position values of elements in class: 
		equiv_class := []; 
		for j in [1 .. Length(class)] do 
			equiv_class[DTP_Seq_i(letter1, class[j]).pos] := 1; 
		od; 
		
		# See if there exist subletters of letter2 in the same class, for this
		# go through all representative of distinct almost equality classes
		# of Sub(letter2):
		found_letter2_class := false; 
		for k in [1 .. Length(classes_letter2)] do 
			if not k in has_class then # if this class was not matched yet 
				if DTP_AreAlmostEqual(rep, sequence_letter2[classes_letter2[k][1]]) then 
					
					Add(has_class, k); 
					for j in [1 .. Length(classes_letter2[k])] do 
						equiv_class[sequence_letter2[classes_letter2[k][j]].pos] := 1; 
					od;
					found_letter2_class := true; 
					break; 
				fi; 
			fi; 
		od; 
		
		# Check criterion for least letters: Each almost equality class A 
		# must fulfil {pos(rho) | rho \in A} = {1, ..., |A|}. 
		# Since we are only interested in least letters, we may return if 
		# it is not fulfilled. 
		if not IsDenseList(equiv_class) then 
			return false; 
		fi; 
		
		Add(classes_size, Length(equiv_class)); 
		
		elms := []; 
		
		if letter1left then # letter1 = left 
			Append(elms, classes_letter1[i]); 
			if found_letter2_class then 
				# found also a class of Sub(letter2)
				# Since letter2 is the right part of the letter, add the 
				# length of letter1 to the index of the subletters 
				Append(elms, classes_letter2[k] + letter1.l); 
			fi; 
		else # letter2 = left
			if found_letter2_class then 
				Append(elms, classes_letter2[k]); 
			fi; 
			Append(elms, classes_letter1[i] + letter2.l); 
		fi;
		Add(classes_elms, elms); 
	od; 
	
	
	# Now go through the remaining classes of letter2: 
	for i in [1 .. Length(classes_letter2)] do 
		if not i in has_class then 
			class := classes_letter2[i]; 
			rep := sequence_letter2[class[1]]; 
			Add(classes_reps, rep); 
			
			equiv_class := []; 
			for j in [1 .. Length(class)] do 
				equiv_class[sequence_letter2[class[j]].pos] := 1; 
			od; 
			
			# Check least criterion on this class as above. 
			if not IsDenseList(equiv_class) then 
				return false; 
			fi; 
			
			Add(classes_size, Length(equiv_class)); 
			
			if letter1left then # letter1 = left 
				Add(classes_elms, classes_letter2[i] + letter1.l); 
			else 
				Add(classes_elms, classes_letter2[i]); 
			fi; 
		fi; 
	od; 
	
	# Notice: The constructed letter itself is missing in classes_reps. The 
	# size of its almost equality class is always one (because there exists 
	# only one subletter of this length). So independent of the num value we
	# may add 1 to classes_size: 
	Add(classes_size, 1); 
	# Furthermore, we can add the corresponding component to classes_elms: 
	Add(classes_elms, [left.l + right.l + 1]); 
	# So, when going through the innerst for-loop in DTP_ComputeSetReps, we 
	# only have to add the number to the record and add the letter itself to 
	# its classes_reps, in order to update the following output to be valid
	# (i.e. as if called DTP_StructureLetter): 
	
	return [classes_reps, classes_size, rec( pos := 1, left := left, right := right, l := left.l + right.l + 1), classes_elms]; 
end; 
