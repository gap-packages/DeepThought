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
		
		# test Order (not included in time)
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

TestDTPPackage := function()
	local coll_list, coll, pk, p, k, num, j, nr, H, coll_paper, coll_cyclic, coll_finite; 
	
	coll_paper := FromTheLeftCollector(4);
	SetConjugate(coll_paper, 2, 1, [2, 1, 3, 2]);
	SetConjugate(coll_paper, 3, 1, [3, 1, 4, 1]);
	SetConjugate(coll_paper, 3, 2, [3, 1, 4, 5]);
	UpdatePolycyclicCollector(coll_paper);

	coll_finite := FromTheLeftCollector(3);
	SetRelativeOrder(coll_finite, 1, 15);
	SetRelativeOrder(coll_finite, 2, 10);
	SetRelativeOrder(coll_finite, 3, 3); 
	UpdatePolycyclicCollector(coll_finite);

	coll_cyclic := FromTheLeftCollector(1);
	SetRelativeOrder(coll_cyclic, 1, 3628800);
	UpdatePolycyclicCollector(coll_cyclic);
	
	coll_list := [ 	[ coll_paper, 100, 500],  
					[ coll_finite, 100, 500], 
					[ coll_cyclic, 100, 1000],
					[ Collector(UnitriangularPcpGroup(3, 0)), 500, 500],
					[ Collector(UnitriangularPcpGroup(5, 0)), 100, 100], 
					[ Collector(HeisenbergPcpGroup(3)), 1000, 100],
					[ Collector(HeisenbergPcpGroup(7)), 300, 100],
					[ Collector(HeisenbergPcpGroup(30)), 10, 10],
					[ Collector(BurdeGrunewaldPcpGroup(0, 1)), 10, 10],
					[ Collector(BurdeGrunewaldPcpGroup(9, 7)), 10, 10],
					[ Collector(ExamplesOfSomePcpGroups(11)), 100, 500],
					[ Collector(ExamplesOfSomePcpGroups(12)), 100, 500],
					[ Collector(ExamplesOfSomePcpGroups(15)), 10, 10],
					[ Collector(ExamplesOfSomePcpGroups(16)), 10, 10] ];
	
	for coll in coll_list do 
		Print("Test collector ", coll, "... \n"); 
		Test_DTP_functions(coll[1], true, coll[2], coll[3]);
		Test_DTP_functions(coll[1], false, coll[2], coll[3]); 
	od;
	
	Print("Test some finite groups... \n"); 
	for pk in [[2, 5], [2, 8], [5, 2], [5, 4], [7, 3], [23, 4]] do 
		p := pk[1];
		k := pk[2]; 
		num := NrSmallGroups(p^k);
		for j in [1 .. 3] do 
			nr := Random([1 .. num]);
			H := PcGroupToPcpGroup(SmallGroup(p^k, nr));
			coll := Collector(H); 
			Test_DTP_functions(coll, true, 1000, 1000); 
			Test_DTP_functions(coll, false, 1000, 1000);
		od;
	od;
	
	Print("Test some random collectors... \n"); 
	for j in [1 .. 10] do 
		Test_DTP_functions(DTP_rand_coll(), true, 100, 1000); 
		Test_DTP_functions(DTP_rand_coll(), false, 100, 1000);
	od; 
	
	return true; 
end;
