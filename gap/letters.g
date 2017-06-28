# This file contains the functions:
#	DTP_IsAtom
#	DTP_SequenceLetter
#	DTP_LengthLetter
#	DTP_AreEqualLetters
#	DTP_AreAlmostEqual
#	DTP_HaveSameStructure
#	DTP_AreSimLetters
#
# REMARK Many functions in this file are not used currently. 

# This file contains basic functions concerning letters, which are 
# implemented as records. In the following, letter1, letter2 are always letters
# given as records: 
# If letter1 is an atom (side(letter1), num(letter1), pos(letter1)), i.e.
# num_pos^{side}, then 
#	letter1 := rec( num := 1, pos := 3, side := DT_left, l := 1)
# where num, pos are positive integers and side is a global variable, either
DT_left := 0;
# or
DT_right := 1;

# In "l" we store the length of a letter. 
# If letter1 is a non-atom:
#	letter1 := rec( num := 1, pos := 3, left := rec( ...), right := rec( ...), l := 3 )
# where "left" and "right" are letters given as records and l denotes the 
# length of letter1, i.e. l = left.l + right.l + 1. 
#############################################################################

# Input: letter letter1
# Output: 	* true, if letter1 is an atom
#			* false, if alplha is a non-atom
DTP_IsAtom := function(letter1)
	return IsBound(letter1.side);
end;

# Input: letter letter1
# Output: length of letter1 // length of Seq(letter1)
DTP_LengthLetter := function(letter1)
    if IsBound(letter1.side) then # letter1 is an atom
		return 1;
	else # letter1 is non-atom
		return DTP_LengthLetter(letter1.left) + DTP_LengthLetter(letter1.right) + 1;
	fi;
end;

# Input: letters letter1, letter2
# Output: 	* true, if letter1 and letter2 are equal
#			* false, otherwise
### it's slightly faster to call letter1 = letter2 directly 
DTP_AreEqualLetters := function(letter1, letter2)
	return letter1 = letter2; # use equality for records 
end;

# Input: letters letter1, letter2
# Output: 	* true, if letter1 and letter2 are almost equal
#			* false, otherwise
InstallGlobalFunction( DTP_AreAlmostEqual,
function(letter1, letter2)
	local is_atom; 
	
	# In any case we must have letter1.num = letter2.num
	# and both must have the same length
	if (letter1.num <> letter2.num) or (letter1.l <> letter2.l) then
		return false;
	fi;
	
	# check whether both are atoms / non-atoms:
	is_atom := IsBound(letter1.side); # true <=> letter1 is atom 
	if is_atom = IsBound(letter2.side) then
		if is_atom then # both are atoms
			return (letter1.side = letter2.side);
		else # both are non-atoms
			return (letter1.left = letter2.left and letter1.right = letter2.right);
		fi;
	else # one is an atom, the other one a non-atom
		return false;
	fi;
end );

# Input: letters letter1, letter2
# Output: 	* true, if letter1 and letter2 have the same structure
#			* false, otherwise
DTP_HaveSameStructure := function(letter1, letter2)
	local is_atom;
	
	# in any case we must have letter1.num = letter2.num and both must have the 
	# same length 
	if (letter1.num <> letter2.num) or (letter1.l <> letter2.l) then
		return false;
	fi;
	
	# check whether both are atoms / non-atoms
	is_atom := IsBound(letter1.side); # true <=> letter1 is atom
	if is_atom = IsBound(letter2.side) then
		if is_atom then # both are atoms
			if letter1.side = letter2.side then
				return true;
			else
				return false;
			fi;
		else # both are non-atoms
			return (DTP_HaveSameStructure(letter1.left, letter2.left) and DTP_HaveSameStructure(letter1.right, letter2.right));
		fi;
	else # one is an atom, the other one a non-atom
		return false;
	fi;
end;

# Input: integers a, b
# Ouput: 	* 1, if a < b
#			* 0, if a = b
#			* -1, if a > b
DTP_compare_numbers := function(a, b);
	if a < b then
		return 1;
	elif a = b then
		return 0;
	else # a > b
		return -1;
	fi;
end;

# Input: letters letter1, letter2
# Output: 	* true, if letter1 and letter2 are in ~-relation
#			* false, otherwise
DTP_AreSimLetters := function(letter1, letter2)
	local Seq_letter1, Seq_letter2, len, i, j, alm_equal;
	
	# letter1 and letter2 must have the same structure 
	if DTP_HaveSameStructure(letter1, letter2) then
		# both have the same structure 
		Seq_letter1 := DTP_SequenceLetter(letter1);
		Seq_letter2 := DTP_SequenceLetter(letter2);
		# now DTP_LengthLetter(letter1) = DTP_LengthLetter(letter2) (since same structure)
		len := Length(Seq_letter1);
		for i in [1 .. len] do 
			for j in [1 .. len] do
				# check Seq(letter1, i) almost equal to Seq(letter1, j)
				# <=> Seq(letter2, i) almost equal to Seq(letter2, j)
				alm_equal := DTP_AreAlmostEqual(Seq_letter1[i], Seq_letter1[j]);
				if alm_equal <> DTP_AreAlmostEqual(Seq_letter2[i], Seq_letter2[j]) then
					return false;
				elif alm_equal then # check relation of positions 
					if DTP_compare_numbers(Seq_letter1[i].pos, Seq_letter1[j].pos) <> DTP_compare_numbers(Seq_letter2[i].pos, Seq_letter2[j].pos) then
						return false;
					fi;
				fi;
			od;
		od; 
		return true; 
	else # letter1 and letter2 don't have the same structure
		return false; 
	fi;
end;