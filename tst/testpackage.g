# test DTP functions 
Test_DTP_functions := function(coll, rs_flag, r, lim)
	local G_c, dt, i, g_c, h_c, g_expvec, h_expvec, g, h, z, res_c, res_pcp, res_expvec, ord;
	
	G_c := PcpGroupByCollector(coll);
	dt := DTP_DTObjFromCollector(coll, rs_flag); 
	
	for i in [1 .. r] do 
		g_c := Random(G_c);
		h_c := Random(G_c); 
		g_expvec := ShallowCopy(Exponents(g_c));
		h_expvec := ShallowCopy(Exponents(h_c));
		g := PcpElementByExponents(dt, g_expvec); 
		h := PcpElementByExponents(dt, h_expvec);
		
		# test Exp
		z := Random([-lim .. lim]); 
		res_c := g_c^z; 
		res_pcp := DTP_PCP_Exp(g, z); 
		res_expvec := DTP_Exp(g_expvec, z, dt); 
		if not (Exponents(res_c) = Exponents(res_pcp) 
		and Exponents(res_c) = res_expvec) then 
			Error("in Exp"); 
		fi; 
			
		# test Inverse 
		res_c := g_c^-1;
		res_pcp := DTP_PCP_Inverse(g);
		res_expvec := DTP_Inverse(g_expvec, dt); 
		if not (Exponents(res_c) = Exponents(res_pcp) 
		and Exponents(res_c) = res_expvec) then 
			Error("in Inv"); 
		fi; 

		res_c := h_c^-1;
		res_pcp := DTP_PCP_Inverse(h);
		res_expvec := DTP_Inverse(h_expvec, dt);
		if not (Exponents(res_c) = Exponents(res_pcp) 
		and Exponents(res_c) = res_expvec) then 
			Error("in Inv"); 
		fi; 
		
		ord := Order(g_c); 
		if not (ord = DTP_PCP_Order(g)
		and ord = DTP_Order(g_expvec, dt)) then
			Error("in Order"); 
		fi; 
		
		ord := Order(h_c);
		if not (ord = DTP_PCP_Order(h)
		and ord = DTP_Order(h_expvec, dt)) then
			Error("in Order"); 
		fi; 
		
		# test SolveEquation
		res_c := g^-1 * h;
		res_pcp := DTP_PCP_SolveEquation(g, h);
		res_expvec := DTP_SolveEquation(g_expvec, h_expvec, dt); 
		if not (Exponents(res_c) = Exponents(res_pcp) 
		and Exponents(res_c) = res_expvec) then 
			Error("in SolveEquation"); 
		fi; 
		
		res_c := h^-1 * g;
		res_pcp := DTP_PCP_SolveEquation(h, g);
		res_expvec := DTP_SolveEquation(h_expvec, g_expvec, dt);
		if not (Exponents(res_c) = Exponents(res_pcp) 
		and Exponents(res_c) = res_expvec) then 
			Error("in SolveEquation"); 
		fi; 
		
		# test Multiply
		res_c := g_c * h_c;
		res_pcp := g * h;
		res_expvec := DTP_Multiply(g_expvec, h_expvec, dt); 
		if not (Exponents(res_c) = Exponents(res_pcp) 
		and Exponents(res_c) = res_expvec) then 
			Error("in Multiply"); 
		fi; 
	od; 
	
	return true; 
end;

# Use Lemma 2 in Eick/Engel paper 
# 	"Hall polynomials for the torsion free nilpotent groups of Hirsch length
#	at most 5"
# to find a consistent presentation:
# If n = 5, then presentation is consistent if and only if 
# t123 * t345 = 0 and t124 * t345 + t145 * t234 = t134 * t245
DTP_rand_coll := function()
	local t123, t345, t124, t145, t234, t134, t245, t125, t135, t235, rand, factors, collector, n, i; 
	
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
	
	return collector; 
end; 