# This function may be used to compare polynomials f_r, 1 <= r <= n, with 
# polynomials computed by EE (Eick, Engel, see paper "Hall polynomials for 
# the torsion free nilpotent groups of Hirsch length at most 5")

# for i in [1 .. 1000] do 
# 	if not DTP_CompareEE_r() then 
# 		Error(); 
# 	fi; 
# od; 

DTP_CompareEE_r := function()
	local n, r, l, i, term, g_alpha, flag, j, t123, t345, t124, t145, t234, t134, t245, t125, t135, t235, rand, factors, collector, f1, f2, f3, f4, f5, ee, fr; 

	# Use Lemma 2 in Eick/Engel paper to find a consistent presentation:
	# If n = 5, then presentation is consistent if and only if 
	# t123 * t345 = 0 and t124 * t345 + t145 * t234 = t134 * t245

	# one of these has to be 0 
	rand := Random(0, 1);
	if rand = 1 then 
		t123 := 0; 
		t345 := Random([-1000 .. 1000]); 
	else
		t123 := Random([-1000 .. 1000]); 
		t345 := 0;
	fi; 

	# t124 * t345 + t145 * t234 = t134 * t245
	t124 := Random([-1000 .. 1000]); 
	t145 := Random([-1000 .. 1000]);
	t234 := Random([-1000 .. 1000]);
	factors := Factors(t124 * t345 + t145 * t234);
	t134 := 1;
	t245 := 1;
	for i in [1 .. Length(factors)] do 
		if Random(0, 1) = 1 then 
			t134 := t134 * factors[i]; 
		else
			t245 := t245 * factors[i]; 
		fi; 
	od; 

	# can be chosen arbitrarily 
	t125 := Random([-1000 .. 1000]);
	t135 := Random([-1000 .. 1000]);
	t235 := Random([-1000 .. 1000]);

	n := 5; 
	collector := FromTheLeftCollector(n);
	SetConjugate(collector, 2, 1, [2, 1, 3, t123, 4, t124, 5, t125]);
	SetConjugate(collector, 3, 1, [3, 1, 4, t134, 5, t135]);
	SetConjugate(collector, 4, 1, [4, 1, 5, t145]); 
	SetConjugate(collector, 3, 2, [3, 1, 4, t234, 5, t235]);
	SetConjugate(collector, 4, 2, [4, 1, 5, t245]); 
	SetConjugate(collector, 4, 3, [4, 1, 5, t345]); 
	UpdatePolycyclicCollector(collector);
	
	# polynomials by EE (theorem 3): 
	
	f1 := [ [1, [1, 1] ], [1, [n + 1, 1] ] ];

	f2 := [ [1, [2, 1] ], [1, [n + 2, 1] ] ];

	f3 := [ [1, [3, 1] ], [1, [n + 3, 1] ], [t123, [2, 1], [n + 1, 1] ] ];

	f4 := [ [1, [4, 1] ], [1, [n + 4, 1] ],
	[t124, [2, 1], [n + 1, 1] ],
	[t134, [3, 1], [n + 1, 1] ],
	[t234, [3, 1], [n + 2, 1] ],
	[t123 * t134, [2, 1], [n + 1, 2] ],
	[t123 * t234, [2, 2], [n + 1, 1] ],
	[t123 * t234, [2, 1], [n + 1, 1], [n + 2, 1] ] ];

	f5 := [ [1, [5, 1] ], [1, [n + 5, 1] ],
	[t345, [4, 1], [n + 3, 1] ],
	[t245, [4, 1], [n + 2, 1] ],
	[t235, [3, 1], [n + 2, 1] ], 
	[t145, [4, 1], [n + 1, 1] ],
	[t135, [3, 1], [n + 1, 1] ], 
	[t125, [2, 1], [n + 1, 1] ],
	[t234 * t345, [3, 2], [n + 2, 1] ],
	[t234 * t245, [3, 1], [n + 2, 2] ],
	[t134 * t345, [3, 2], [n + 1, 1] ],
	[t134 * t145, [3, 1], [n + 1, 2] ],
	[t234 * t345, [3, 1], [n + 2, 1], [n + 3, 1] ],
	[t134 * t345, [3, 1], [n + 1, 1], [n + 3, 1] ],
	[t134 * t245, [3, 1], [n + 1, 1], [n + 2, 1] ],
	[t124 * t345, [2, 1], [n + 1, 1], [n + 3, 1] ],
	[t124 * t345, [2, 1], [3, 1], [n + 1, 1] ],
	[t123 * t235, [2, 1], [n + 1, 1], [n + 2, 1] ],
	[t124 * t245, [2, 1], [n + 1, 1], [n + 2, 1] ],
	[t123 * t235, [2, 2], [n + 1, 1] ],
	[t124 * t245, [2, 2], [n + 1, 1] ],
	[t123 * t135, [2, 1], [n + 1, 2] ],
	[t124 * t145, [2, 1], [n + 1, 2] ],
	[t123 * t234 * t245, [2, 1], [n + 1, 1], [n + 2, 2] ],
	[t123 * t134 * t245, [2, 2], [n + 1, 2] ],
	[t123 * t234 * t245, [2, 3], [n + 1, 1] ],
	[t123 * t134 * t145, [2, 1], [n + 1, 3] ],
	[t123 * t234 * t245, [2, 2], [n + 1, 1], [n + 2, 1] ],
	[t123 * t134 * t245, [2, 1], [n + 1, 2], [n + 2, 1] ]];

	ee := [f1, f2, f3, f4, f5]; 

	# delete polynomials with g_alpha[1] = 0 in ee:
	for r in [1 .. n] do 
		l := Length(ee[r]); 
		for j in Reversed([1 .. l]) do 
			if ee[r][j][1] = 0 then 
				Remove(ee[r], j);
			fi; 
		od;
	od; 
	
	# If f_r = c_1 * f + c_2 * f + g simplify it: f_r = (c_1 + c_2) * f + g
	for r in [1 .. n] do 
		i := 1; 
		while i <= Length(ee[r]) do  # polynomial f_r = ee[i]
			term := ee[r][i]; # check if there exist similar (equal except of 
								# constant coefficient) terms in this
								# polynomial and simplify them 
			for j in Reversed([(i + 1) .. Length(ee[r])]) do 
				if Length(term) = Length(ee[r][j]) and 
				term{[2 .. Length(term)]} = ee[r][j]{[2 .. Length(ee[r][j])]} then 
					term[1] := term[1] + ee[r][j][1]; 
					Remove(ee[r], j); 
				fi; 
			od; 
			i := i + 1; 
		od; 
	od; 

	# polynomials by nw
	fr := DTP_DTObjFromCollector(collector, false)![PC_DTPPolynomials]; 

	# compare: 
	n := Length(fr); 
	for r in [1 .. n] do 
		if Length(ee[r]) <> Length(fr[r]) then 
			Error("different number of terms in polynomial f_", r, "\n"); 
		else # both have same length
			# go through all terms in ee[r] and check whether there 
			# exists a list describing the same term in fr[r]
			l := Length(ee[r]); 
			for i in [1 .. l] do 
				g_alpha := ee[r][i];
				flag := false; 
				# search for g_alpha in fr:
				for j in [1 .. Length(fr[r])] do 
					if Set(g_alpha) = Set(fr[r][j]) then 
						flag := true; 
						break; 
					fi; 
				od; 
				if flag = false then 
					Error("different polynomials for f_", r, "\n"); 
				fi; 
			od; 
		fi;
	od; 
	
	return true; 
end; 