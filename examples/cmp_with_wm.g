MakeReadWriteGlobal("USE_COMBINATORIAL_COLLECTOR");
USE_COMBINATORIAL_COLLECTOR := true;

# Merkwitz' can be found in /usr/local/lib/gap4r5/src, 
# see dt.c and dteval.c. Furthermore, /gap4r5/lib/dt.g.

# DTP_wm2nw converts the Hall polynomials stored in coll![PC_DEEP_THOUGHT_POLS]
# into polynomials of the form used in nw implementation (f_rs)
# Input: 	collector coll 
# Output: 	corresponding polynomials f_rs in format used in nw implementation
DTP_wm2nw := function(coll)
	local pcdtpols, n, f_ji, i, j, c, evlist, evlistvec, l, g_alpha, k, m, pols, t;
	
	# compute Hall polynomials by WM
	if coll![PC_DEEP_THOUGHT_POLS] = [] then 
		t := Runtime(); 
		AddHallPolynomials(coll);
		t := Runtime() - t; 
		Print("  Time wm polynomials: ", t, "\n"); 
	fi; 
	pcdtpols := coll![PC_DEEP_THOUGHT_POLS];
	
	# pcdtpols is a list of length n = number of generators
	n := Length(pcdtpols); 
	pols := [];
	
	for i in [1 .. n] do 
		f_ji := []; # f_ji[i] describes the polynomial f_ji
		
		# first, add "trivial monomials" X_j and Y_j to each f_ji
		# (those are not represented in pcdtpols)
		for j in [1 .. n] do 
			f_ji[j] := []; 
			if j = i then
				Add(f_ji[j], [1, [j, 1]]); # X_j
				Add(f_ji[j], [1, [n + j, 1]]); # Y_j
			else
				Add(f_ji[j], [1, [j, 1]]); # X_j
			fi;
		od; 
		Add(pols, f_ji); 
	od;
	
	for i in [1 .. n] do 
		if IsRecord(pcdtpols[i]) then 
			# evlist is list of all deep thought monomials occuring 
			# in polynomials f_{i1}, ..., f_{in}
			evlist := pcdtpols[i].evlist; 
			# evlistvec is list of vectors describing the coefficients
			# of the corresponding deep thought monomials in the 
			# polynomials f_{i1}, ..., f_{in}
			evlistvec := pcdtpols[i].evlistvec;
			
			for l in [1 .. Length(evlistvec)] do 
				# get all pairs in "vector"
				for c in [1, 3 .. (Length(evlistvec[l]) - 1)] do 
					g_alpha := []; 
					j := evlistvec[l][c]; 
					k := evlistvec[l][c + 1]; 
					# Interpretation of evlist, evlistvec taken from file 
					# dteval.c in gap/src:
					# "The deep thought polynomials are stored in the list 
					# <dtpols> where <dtpols>[i] contains the polynomials 
					# f_{i1},...,f_{in}. <dtpols>[i] is a record consisting of 
					# the components <evlist> and <evlistvec>. <evlist> is a 
					# list of all deep thought monomials occuring in the 
					# polynomials f_{i1},...,f_{in}. <evlistvec> is a list of
					# vectors describing the coefficients of the corresponding
					# deep thought monomials in the polynomials f_{i1},..,f_{in}.
					#
					# For example when a pair [j,k] occurs in 
					# <dtpols>[i].<evlistvec>[l] then the deep thought monomial 
					# <dtpols>[i].<evlist>[l] occurs in f_{ij} with the
					# coefficient k. If the polynomials f_{i1},..,f_{in} are 
					# trivial i.e. f_{ii} = x_i + y_i and f_{ij} = x_j (j<>i), 
					# then <dtpols>[i] is either 1 or 0. <dtpols>[i] is 0 if also 
					# the polynomials f_{m1},...,f_{mn} for (m > i) are trivial."
					
					# Now the deep thought monomial 
					# 	"<dtpols>[i].<evlist>[l]" = evlist[l] 
					# occurs in f_{ij} with the coefficient k:
					g_alpha[1] := k; 
					for m in [5, 7 .. Length(evlist[l]) - 1] do 
						if evlist[l][m] = 0 then 
							Add(g_alpha, [ n + i, evlist[l][m + 1] ] );
						else 
							Add(g_alpha, [evlist[l][m], evlist[l][m + 1] ] );
						fi; 
					od; 
					Add(pols[i][j], g_alpha);
				od; 
			od; 
		fi;  
	od; 

	return pols; 
end;

# compares for a collector coll the polynomials computed by wm and nw
DTP_ComparePolynomials := function(coll, DTobj...)
	local all_pols_nw, all_pols_wm, pols_f_rs_nw, pols_f_rs_wm, n, r, l, i, g_alpha, flag, j, t, s, equal, coeffs, orders; 
#	Print("Notice that even if this function returns 'false', by summarizing terms the polynomials may nevertheless be equal.\n"); 
	
	all_pols_wm := DTP_wm2nw(coll); 
	
	if Length(DTobj) = 0 then 
		t := Runtime(); 
		all_pols_nw := DTP_DTpols_rs(coll); 
		t := Runtime(); 
		Print("Time for DTP_DTpols_rs:\n", t - t, "\n"); 
	else
		all_pols_nw := DTobj[1]; 
	fi; 
	
	orders := all_pols_nw[3]; 
	n := NumberOfGenerators(coll); 
	equal := true; 
	coeffs := true; 
	for s in [1 .. n] do 
		# get polynomials f_1, s, ...., f_n, s
		pols_f_rs_nw := all_pols_nw[2][s]; 
		pols_f_rs_wm := all_pols_wm[s]; 
		for r in [1 .. n] do # consider polynomial f_r, s
			if Length(pols_f_rs_nw[r]) <> Length(pols_f_rs_wm[r]) then 
				Print("different number of terms in polynomial f_", r, ", ", s, "\n"); 
				equal := false; 
			else # both have same length
				# go through all terms in pols_f_rs_wm[r] and check whether there 
				# exists a list describing the same term in pols_f_rs_nw[r]
				l := Length(pols_f_rs_wm[r]);
				for i in [1 .. l] do 
					g_alpha := pols_f_rs_wm[r][i];
					flag := false; 
					# search for g_alpha in pols_f_rs_nw[r]:
					for j in [1 .. Length( pols_f_rs_nw[r]) ] do 
						# first compare the binomial coefficients with indeterminates 
						if Set(g_alpha{[2 .. Length(g_alpha)]}) = Set(pols_f_rs_nw[r][j]{[2 .. Length(pols_f_rs_nw[r][j])]}) then
							# now check whether also the constant coefficient is equal 
							if g_alpha[1] = pols_f_rs_nw[r][j][1] then 
								# both are equal 
								flag := true; 
								break; 
 							elif g_alpha[1] mod orders[r] = pols_f_rs_nw[r][j][1] mod orders[r] then 
 								flag := true;
 								break; 
							else
								# equal except of the coefficient 
								coeffs := false; 
							fi; 
						fi; 
					od; 
					if flag = false then 
						Print("different polynomials for f_", r, ", ", s, "\n"); 
#						Print("   term ", g_alpha, " not in nw\n"); 
						equal := false; 
					fi; 
				od; 
			fi;
		od;
	od;
	
	if not coeffs then 
		Print("Some (or all) terms differ only by the constant coeffiecient.\n"); 
	fi; 
	
	return equal; 
end; 

DTP_CompareMultis := function(coll, num) 
	local DTobj, i, x, y, k, z, z_collect, z_pols_wm, z_pols_nw, t, t_pols_wm, t_pols_nw, t_coll, lim, x1, y1, orders, rel, j, n, t_pols_nw_ord, z_pols_nw_ord; 
	
	lim := 100; 
	
	if coll![PC_DEEP_THOUGHT_POLS] = [] then 
		t := Runtime(); 
		AddHallPolynomials(coll);
		t := Runtime() - t; 
		Print("WM polynomials computed in ", t, " ms \n"); 
	fi; 
	
	t := Runtime();
	DTobj := DTP_DTpols_rs(coll); 
	t := Runtime() - t;
	Print("NW polynomials f_rs computed in ", t, " ms \n"); 

	t_pols_nw := 0;
	t_pols_nw_ord := 0; 
	t_pols_wm := 0; 
	t_coll := 0;
	rel := RelativeOrders(coll); 
	n := NumberOfGenerators(coll); 
	orders := DTobj[3]; 
		
	for i in [1 .. num] do
		# generate num random elements (in normal form) with exponent vectors' 
		# entries between -lim and lim 
		x := []; 
		y := []; 
		for j in [1 .. n] do
			if rel[j] <> 0 then # exponent vectors in normal form: 
				Add(x, Random([0 .. Minimum(lim, rel[j] - 1)]));  
				Add(y, Random([0 .. Minimum(lim, rel[j] - 1)]));       
			else 
				Add(x, Random([-lim .. lim]));  
				Add(y, Random([-lim .. lim]));                          
			fi; 
		od; 
		
		# multiply with nw pols
		t := Runtime();
		z_pols_nw := DTP_Multiply_rs(x, y, DTobj);
		t := Runtime() - t;
		t_pols_nw := t_pols_nw + t; 
		
		# multiply using collection  
		y1 := ObjByExponents(coll, Exponents(PcpElementByExponents(coll, y)));
		z_collect := ShallowCopy(Exponents(PcpElementByExponents(coll, x))); 
		t := Runtime(); 
#		CollectPolycyclicGap(coll, z_collect, y1); # result is stored in z_collect
		t := Runtime() - t;
		t_coll := t_coll + + t; 
		
		# multiply with wm pols 
		x1 := ObjByExponents(coll, x);
		y1 := ObjByExponents(coll, y);
		t := Runtime(); 
		z_pols_wm := DTMultiply(x1, y1, coll); 
		t := Runtime() - t;
		t_pols_wm := t_pols_wm + t; 
		z_pols_wm := ExponentsByObj(coll, z_pols_wm); 
		
		# compare results: 
		if not (z_pols_nw = z_pols_wm) then #or not (z_collect = z_pols_wm) then 
			Error("different results for input:\nx := ", x, "\ny := ", y, "\n"); 
		fi; 
	od;

	Print("  t_coll: ", t_coll, "\n  t_pols_nw: ", t_pols_nw, "\n  t_pols_nw_ord: ", t_pols_nw_ord, "\n  t_pols_wm: ", t_pols_wm, "\n"); 
	
	return true; 
end; 

DTP_CompareAll := function()
	local colls, c, p, k, num, j, nr, G, H, t; 
	
	t := Runtime(); 
	
	# finite groups
	for p in [2, 3, 5, 11] do
		for k in [3 .. 6] do 
			Print("p: ", p, ", k: ", k, "\n");
			num := NrSmallGroups(p^k);
			for j in [1 .. 10] do 
				nr := Random([1 .. num]); 
				G := SmallGroup(p^k, nr);
				H := PcGroupToPcpGroup(G);
				c := Collector(H); 
				if not DTP_ComparePolynomials(c) then 
					Error();
				fi; 
			od; 
		od;
	od;
	
	colls := [coll_paper, coll_finite, coll_cyclic, UT_3, UT_5, 
	UT_10, heisenberg_3, heisenberg_7, heisenberg_30, heisenberg_50, 
	ex11, ex12, DTP_rand_coll(), ex15, ex16, 
	BG_01, BG_97, ex14]; 

	for c in colls do 
		if not DTP_ComparePolynomials(c) then 
			Error();
		fi; 
	od; 
	
	t := Runtime() - t; 
	Print("Time: ", t, "\n"); 
	return true; 
end; 