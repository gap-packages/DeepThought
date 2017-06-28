# This file contains the functions:
#	DTP_LeftOf
#############################################################################

# Input: letters left <> right which occur during a collection to the left
# Output: 	- true,		if at the first instance that left and right both
#						label generators, the generators labelled by left
#						is to the left of the generator labelled by right
#			- false,	otherwise 
DTP_LeftOf := function(left, right)
	local is_atom_left, is_atom_right, earlier; 
	
	# IsBound(letter.side) <=> letter is an atom 
	is_atom_left := IsBound(left.side); 
	is_atom_right := IsBound(right.side); 
	
	if is_atom_left and is_atom_right then # both are atoms
		if left.side = DT_left and right.side = DT_right then 
			return true;
		elif left.side = DT_right and right.side = DT_left then 
			return false;
		elif left.num = right.num then 
			# now both belong to the same side and label the same generator
			return left.pos < right.pos;
		fi; 
		return left.num < right.num;
	fi; 
	# now at least one letter is a non-atom 
	if (not is_atom_left and not is_atom_right) # both are non-atoms
	and (left.right = right.right) and (left.left = right.left) then
		if left.num = right.num then
			return left.pos < right.pos;
		fi; 
		return left.num < right.num;
	fi; 
	
	# Find out if left or right occurred earlier:
	# "earlier" is a boolean which is true if and only if left occurred
	# strictly earlier during a collection than right
	if is_atom_left then
		earlier := true; 
	elif is_atom_right then
		earlier := false;
	elif left.right = right.right then
		earlier := DTP_LeftOf(right.left, left.left);
	elif left.right.num = right.right.num then
		earlier := DTP_LeftOf(left.right, right.right);
	else
		earlier := (left.right.num < right.right.num);
	fi;
	
	# make sure that right occurred earlier than left
	if earlier then
		return not DTP_LeftOf(right, left);
	fi; 
	
	# now left must be a non-atom and we may access its left and right part
	if right.num < left.right.num then
		return false;
	fi;
	if right = left.right then
		return false;
	fi;
	if right.num = left.right.num then
		return DTP_LeftOf(left.right, right); 
	fi;
	# now right.num > left.right.num
	if right = left.left then 
		return false;
	fi;
	return DTP_LeftOf(left.left, right); 
end;