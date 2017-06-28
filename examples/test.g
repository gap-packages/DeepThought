ReadPackage("DeepThought", "examples/cmp_with_wm.g"); 
ReadPackage("DeepThought", "examples/EickEngel.g"); 

# tests num-times multiplications in coll with exponent limit lim
DTP_TestMulti :=  function(coll, num, lim, opt...) 
	local DTobj, i, x, y, y1, k, z, z_gr, t, t_pols, t_coll, orders, n, rel, multiply;
	
	n := NumberOfGenerators(coll); 
	
	if Length(opt) = 0 then 
		t := Runtime();
		DTobj := DTP_DTpols_rs(coll); 
		multiply := DTP_Multiply_rs; 
	#	DTobj := DTP_DTpols_r(coll); 
	#	multiply := DTP_Multiply_r; 
		t := Runtime() - t;
		Print("Polynomials in ", t, "\n"); 
	else 
		DTobj := opt[1]; 
		multiply := opt[2]; 
	fi; 
	
	t_pols := 0;
	t_coll := 0;
	rel := RelativeOrders(coll); 
	
	for i in [1 .. num] do
		# generate random exponents x, y
		x := [];
		y := []; 
		for k in [1 .. n] do # only take elements in normal form as input
			if rel[k] <> 0 then 
				Add(x, Random( [0 .. Minimum(lim, rel[k] - 1)] ) );
				Add(y, Random( [0 .. Minimum(lim, rel[k] - 1)] ) ); 
			else 
				Add(x, Random([-lim .. lim]));
				Add(y, Random([-lim .. lim])); 
			fi; 
		od; 
		t := Runtime();
		z := multiply(x, y, DTobj);
		t := Runtime() - t;
		t_pols := t_pols + t; 

		# compare with collection: 
		y1 := ObjByExponents(coll, Exponents(PcpElementByExponents(coll, y)));
		z_gr := ShallowCopy(Exponents(PcpElementByExponents(coll, x))); 
		t := Runtime(); 
		CollectPolycyclicGap(coll, z_gr, y1); # result is stored in z_collect
		t := Runtime() - t;
		t_coll := t_coll + t; 
		
		if not z_gr = z then
			Error("different normal forms! \n"); 
		fi; 
	od;

	Print("    t_coll ", t_coll, "\n    t_pols: ", t_pols, "\n"); 

end; 

# check time needed for computing the polynomials 
DTP_TestTimeForSmallgroups := function(p, k, max)
	local i, G, H, c, t1, t2, num, nr;
	
	num := NrSmallGroups(p^k);
	Print("Checking ", Minimum(max, num), " groups.\n"); 
	
	for i in [1 .. Minimum(max, num)] do 
		nr := Random([1 .. num]); 
		if i mod 1000 = 0 then 
			Print("Checked ", i, " groups. \n"); 
		fi; 
		G := SmallGroup(p^k, nr);
		H := PcGroupToPcpGroup(G);
		c := Collector(H); 
		t1 := Runtime();
		DTP_DTpols_rs(c); 
		t1 := Runtime() - t1;
		# if computation of polynomials takes longer than 1 second, 
		# display information about the group
		if t1 > 500 then
			Print("polynomials f_rs, nr: ", nr, "\n"); 
		fi;
		
		t2 := Runtime();
		DTP_DTpols_r(c); 
		t2 := Runtime() - t2;
		if t2 > 500 then 
			Print("polynomials f_r, nr: ", nr, "\n"); 
		fi; 
		
		if AbsInt(t1 - t2) > 100 then 
			Print("polynomials f_rs vs. f_r : ", t1, ", ", t2, "\n"); 
		fi; 
	od;
end;

DTP_TestMultiInFiniteGroup := function(coll, opt...)
	local DTobj, x, y, y1, t, z, z_gr, t_coll, t_pols, x_gr, y_gr, G, orders, multiply; 
	
	if Length(opt) = 0 then 
		DTobj := DTP_DTpols_rs(coll); 
		multiply := DTP_Multiply_rs; 
	#	DTobj := DTP_DTpols_r(coll); 
	#	multiply := DTP_Multiply_r; 
	else 
		DTobj := opt[1]; 
		multiply := opt[2]; 
	fi; 
	G := PcpGroupByCollector(coll); 
	t_pols := 0;
	t_coll := 0; 
	for x_gr in G do
		x := Exponents(x_gr);
		for y_gr in G do
			y := Exponents(y_gr);
			t := Runtime();
			z := multiply(x, y, DTobj);
			t := Runtime() - t;
			t_pols := t_pols + t; 
			
			# compare with collection: 
			y1 := ObjByExponents(coll, Exponents(PcpElementByExponents(coll, y)));
			z_gr := ShallowCopy(Exponents(PcpElementByExponents(coll, x))); 
			t := Runtime(); 
			CollectPolycyclicGap(coll, z_gr, y1); # result is stored in z_collect
			t := Runtime() - t;
			t_coll := t_coll + t; 
			
			if not z_gr = z then
				Error("different normal forms!"); 
			fi; 
		od;
	od;
	Print("    t_coll: ", t_coll, "\n    t_pols: ", t_pols, "\n"); 
end;

DTP_TestSmallgroups := function()
	local p, k, num, nr, G, H, c, t0, t1, j; 
	for p in Primes do
		if p > 6 and p < 101 then 
		for k in [3, 5, 6] do 
			for j in [1 .. 10] do 
			Print("p: ", p, ", k: ", k, "\n");
			num := NrSmallGroups(p^k);
			for nr in [1 .. num] do 
				G := SmallGroup(p^k, nr);
				H := PcGroupToPcpGroup(G);
				c := Collector(H); 
				t0 := Runtime();
				DTP_DTpols_rs(c); 
				t0 := Runtime() - t0;

				if t0 > 150 then
					Error("rs, nr: ", nr, "\n"); 
				fi;
				 
				t1 := Runtime();
				DTP_DTpols_r(c); 
				t1 := Runtime() - t1;

				if t1 > 150 then
					Error("r, nr: ", nr, "\n"); 
				fi;
				
				if t0 < t1 - 100 then 
					Print("(r, rs) = (", t1, ", ", t0, ")\n"); 
				fi; 
				
#				DTP_TestMultiInFiniteGroup(c); 
			od; 
			od; 
		od;
		fi; 
	od;
end;

DTP_TestCollector := function(coll, num, lim, which)
	local DTobj_r, DTobj_rs, t; 
	
	if which[1] then 
		t := Runtime(); 
		DTobj_r := DTP_DTpols_r(coll); 
		t := Runtime() - t; 
		Print("  Time f_r: ", t, "\n"); 
		DTP_TestMulti(coll, num, lim, DTobj_r, DTP_Multiply_r); 
	fi;
	
	if which[2] then 
		t := Runtime(); 
		DTobj_rs := DTP_DTpols_rs(coll); 
		t := Runtime() - t; 
		Print("  Time f_rs: ", t, "\n"); 
		DTP_TestMulti(coll, num, lim, DTobj_rs, DTP_Multiply_rs); 
		# compare to wm polynomials: 
		if not DTP_ComparePolynomials(coll, DTobj_rs) then 
			Error("Polynomials are not equal to those computed by wm."); 
		fi; 
	fi; 

	return true; 
end; 

ReadPackage("DeepThought", "example/cmp_with_wm.g"); 
ReadPackage("DeepThought", "example/EickEngel.g"); 
DTP_TestDTPackage := function()
	local pk, p, k, num, j, nr, G, H, c; 

	Print("collector coll_paper \n"); 
	DTP_TestCollector(coll_paper, 10000, 10, [true, true]); 
	
	Print("collector coll_finite \n"); 
	DTP_TestCollector(coll_finite, 10000, 10, [true, true]); 

	Print("collector coll_cyclic \n"); 
	DTP_TestCollector(coll_cyclic, 10000, 10, [true, true]); 
	
	Print("collector UT_3 \n"); 
	DTP_TestCollector(UT_3, 10000, 10, [true, true]); 
	
	Print("collector UT_5 \n");
	DTP_TestCollector(UT_5, 1000, 10, [true, true]); 

	Print("collector UT_10 \n"); 
	DTP_TestCollector(UT_10, 10, 5, [false, true]); 

	Print("collector heisenberg_3 \n"); 
	DTP_TestCollector(heisenberg_3, 10000, 10, [true, true]); 
	
	Print("collector heisenberg_7 \n"); 
	DTP_TestCollector(heisenberg_7, 1000, 10, [true, true]); 

	Print("collector heisenberg_30 \n"); 
	DTP_TestCollector(heisenberg_30, 300, 10, [true, true]); 
	
	Print("collector ex11 \n"); 
	DTP_TestCollector(ex11, 10000, 10, [true, true]); 
	
	Print("collector ex12 \n");
	DTP_TestCollector(ex12, 10000, 10, [true, true]); 

	Print("collector ex15 \n"); 
	DTP_TestCollector(ex15, 300, 7, [true, true]); 
		
	Print("collector ex16 \n"); 
	DTP_TestCollector(ex15, 300, 7, [true, true]); 
	
	Print("Test some random collectors \n"); 
	for j in [1 .. 10] do 
		DTP_TestCollector(DTP_rand_coll(), 10000, 10, [true, true]); 
		CompareEE_r(); 
	od; 
	
	Print("Test some finite groups \n"); 
	for pk in [[2, 5], [2, 8], [5, 2], [5, 4], [7, 3]] do 
		p := pk[1];
		k := pk[2]; 
		num := NrSmallGroups(p^k);
		for j in [1 .. 3] do 
			nr := Random([1 .. num]);
			Print("(p, k, nr) = (", p, ", ", k, ", ", nr, ")\n");
			G := SmallGroup(p^k, nr);
			H := PcGroupToPcpGroup(G);
			c := Collector(H); 
			DTP_TestMultiInFiniteGroup(c, DTP_DTpols_r(c), DTP_Multiply_r);
			DTP_TestMultiInFiniteGroup(c, DTP_DTpols_rs(c), DTP_Multiply_rs); 
		od;
	od;
	
	Print("collector ex14 \n"); 
	DTP_TestCollector(ex14, 100, 8, [false, true]); 

	return true; 
end; 
