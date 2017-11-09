# Functions to display Deep Thought polynomials/DTObj
# To display a DTObj use 
#		DTP_Display_DTObj(DTObj).
#
# Display polynomials only: 
# When using the function DTP_DTpols_rs, call 
#		DTP_Display_f_r(DTP_DTpols_rs(...)[2])
# When using the function DTP_DTpols_r, call 
#		DTP_Display_f_r(DTP_DTpols_r(...)[2])

##############################################################################

DTP_Display_Variable := function(k, n)
	if k <= n then
		Print("X_", k);
	else
		Print("Y_", k - n);
	fi;
end; 

DTP_Display_summand := function(summand, n)
	local i; 
	if summand[1] <> 1 then
		Print(summand[1], " * ");
	fi; 
	for i in [2 .. Length(summand)] do 
		if summand[i][2] = 1 then
			DTP_Display_Variable(summand[i][1], n); 
			Print(" "); 
		else	
			Print("Binomial("); 
			DTP_Display_Variable(summand[i][1], n);
			Print(", ", summand[i][2] , ") "); 
		fi; 
	od; 
end; 

# displays output of DTP_DTpols_r_S()
DTP_Display_f_r_S := function(f_r_S)
	local r, i, n; 
	
	if f_r_S = fail then 
		return; 
	fi;
	
	n := Length(f_r_S); 
	
	for r in [1 .. n] do
		Print("f_", r, ",s = ");
		if Length(f_r_S[r]) = 1 then
			DTP_Display_summand(f_r_S[r][1], n);
			Print("\n"); 
		else
			i := 1; 
			for i in [1 .. (Length(f_r_S[r]) - 1)] do
				DTP_Display_summand(f_r_S[r][i], n);
				Print("+ ");
			od; 
			DTP_Display_summand(f_r_S[r][i + 1], n); 
			Print("\n");
		fi;
	od;
	
end;

# display output of function DTP_DTpols_rs(...)[2]
DTP_Display_f_rs := function(f_rs)
	local s;
	for s in [1 .. Length(f_rs)] do
		Print("Polynomials f_rs for s = ", s, ":\n"); 
		DTP_Display_f_r_S(f_rs[s]); 
	od; 
end;

# displays output of function DTP_DTpols_r(...)[2]
DTP_Display_f_r := function(f_r)
	local r, i, n; 
	
	if f_r = fail then 
		return; 
	fi; 
	
	n := Length(f_r); 
	
	for r in [1 .. n] do
		Print("f_", r, " = ");
		if Length(f_r[r]) = 1 then
			DTP_Display_summand(f_r[r][1], n);
			Print("\n"); 
		else
			for i in [1 .. (Length(f_r[r]) - 1)] do
				DTP_Display_summand(f_r[r][i], n);
				Print("+ ");
			od; 
			DTP_Display_summand(f_r[r][i + 1], n); 
			Print("\n");
		fi;
	od;
	
end;

# display a DTObj
InstallGlobalFunction( DTP_Display_DTObj, 
function(DTObj)
	
	if IsInt(DTObj![PC_DTPPolynomials][1][1][1]) then 
		DTP_Display_f_r(DTObj![PC_DTPPolynomials]); 
	else
		DTP_Display_f_rs(DTObj![PC_DTPPolynomials]); 
	fi; 

end); 


##############################################################################

DTP_BinomialPol := function(ind, k)
	local bin, i; 
	bin := ind^0; 
	for i in [1 .. k] do 
		bin := bin * (ind - i + 1) / i; 
	od;
	return bin; 
end;

DTP_g_alphaGAP := function(g_alpha, indets)
	local bincoeff, l, g_alpha_GAP, ind; 
	
	l := Length(g_alpha); 
	g_alpha_GAP := g_alpha[1] * indets[1]^0; # constant factor polynomial
	for bincoeff in [2 .. l] do 
		ind := indets[g_alpha[bincoeff][1]]; 
		g_alpha_GAP := g_alpha_GAP * DTP_BinomialPol(ind, g_alpha[bincoeff][2]); 
	od; 
	
	return g_alpha_GAP;
end; 

# Input: 	DTObj returned by DTpols_r/s
# Output: 	list containing GAP polynomials corresponding to DTObj![PC_DTPPolynomials] and 
#			their polynomial ring Q
InstallGlobalFunction( DTP_pols2GAPpols, 
function(DTObj)
	local n, indets, r, s, Q, DTpols, GAPpols, f_DT, f_GAP, g_alpha;  
	
	n := NumberOfGenerators(DTObj); 
	# create polynomial ring over Q in 2n indeterminates x_1, ..., x_n, y_1, ..., y_n:
	indets := []; 
	for r in [1 .. n] do 
		Add(indets, Indeterminate( Rationals, Concatenation("x", String(r)) ) ); 
		# indeterminate x_i
	od; 
	for r in [1 .. n] do 
		Add(indets, Indeterminate( Rationals, Concatenation("y", String(r)) ) ); 
		# indeterminate y_i
	od; 
	Q := PolynomialRing(Rationals, indets); 
	
	# go through all DT polynomials and create corresponding GAP polynomial:
	DTpols := DTObj![PC_DTPPolynomials]; 
	GAPpols := []; # list of GAP polynomials corresponding to DTpols
	
	if IsInt(DTpols[1][1][1]) then # version with n polynomials, see 
	# "applications.g" for explanation of this criterion 
		for r in [1 .. n] do # go through all polynomials f_1, ..., f_n
			f_DT := DTpols[r]; # polynomial f_r, consists of several g_alpha
			f_GAP := 0 * indets[1]^0; # zero polynomial 
			for g_alpha in f_DT do
				f_GAP := f_GAP + DTP_g_alphaGAP(g_alpha, indets); 
			od;
			Add(GAPpols, f_GAP); 
		od;
	
	else # version with n^2 polynomials
		for s in [1 .. n] do 
			Add(GAPpols, []); 
			for r in [1 .. n] do 
				f_DT := DTpols[s][r]; # polynomial f_rs
				f_GAP := 0 * indets[1]; 
				for g_alpha in f_DT do 
					f_GAP := f_GAP + DTP_g_alphaGAP(g_alpha, indets); 
				od; 
				Add(GAPpols[s], f_GAP); 
			od; 
		od; 
	fi;
	
	return [GAPpols, Q]; 
	# indets = IndeterminatesOfPolynomialRing(Q); 
end) ;  
