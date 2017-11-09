# This file contains functions which are currently not used by the package, 
# but may be useful in the future or for debugging.


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
