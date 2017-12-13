# This file contains the functions:
#	DTP_HaveSameStructure
#

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