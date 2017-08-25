#############################################################################
####					CollectWordOrFail								 ####
#############################################################################

# The function DTP_CollectWordOrFail should have the same input/output as
# the function CollectWordOrFail (see colftl.gi): 

# a and b represent the elements to be multiplied. 
# As an example, when representing the element a_1^6 a_2^{-5} a_3^0 a_4^3 in 
# group with 4 generators a_1, ..., a_4, then: 
# - a = [6, -5, 0, 3]
# - b = [1, 6, 2, -5, 4, 3]

DTP_CollectWordOrFail := function( DTObj, a, b) 
	local multiply, b1, res, i, coll; 
	
	coll := DTObj; 
	
	# decide which polynomials were computed (either f_r or f_rs) for coll
	# in order to choose the correct multiplication function: 
	if IsInt(DTObj![PC_DTPPolynomials][1][1][1]) then 
		multiply := DTP_Multiply_r; 
	else
		multiply := DTP_Multiply_rs; 
	fi; 

	# since multiply expects exponent vectors, transform genexp:
	b1 := ExponentsByObj(coll, b); 
	
	res := multiply(a, b1, DTObj); 
	
	# the result of the multiplication is stored in a: 
	for i in [1 .. Length(a)] do 
		a[i] := res[i]; 
	od; 
	
	return true; 
end; 

# Example: 
#
# a := [1, 1, 1, 1, 1]; b := [1, 1, 1, 1, 1];
# [ 1, 1, 1, 1, 1 ]
# [ 1, 1, 1, 1, 1 ]
# gap> b := ObjByExponents(ex11, b);
# [ 1, 1, 2, 1, 3, 1, 4, 1, 5, 1 ]
# gap> coll := ex11;; 
# gap> DTObj := DTP_DTpols_r(ex11);; 
# gap> CollectWordOrFail(coll, a, b); 
# true
# gap> a; b; 
# [ 2, 2, 3, 3, 4 ]
# [ 1, 1, 2, 1, 3, 1, 4, 1, 5, 1 ]
# 
# gap> a := [1, 1, 1, 1, 1]; b := [1, 1, 1, 1, 1];
# [ 1, 1, 1, 1, 1 ]
# [ 1, 1, 1, 1, 1 ]
# gap> b := ObjByExponents(ex11, b);
# [ 1, 1, 2, 1, 3, 1, 4, 1, 5, 1 ]
# gap> DTP_CollectWordOrFail(DTObj, a, b); 
# true
# gap> a; b; 
# [ 2, 2, 3, 3, 4 ]
# [ 1, 1, 2, 1, 3, 1, 4, 1, 5, 1 ]