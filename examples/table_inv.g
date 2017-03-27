invtab := function(G, lim)
	local coll, n, elms, elms_gr, i, DTobj_r, DTobj_rs, invcoll, invr, invrs, x, avg_invcoll, avg_inv_r, avg_inv_rs, invc, inv_r, inv_rs, k, rel;
	
	coll := Collector(G); 
	n := NumberOfGenerators(coll); 
	
	invc := []; invr := []; invrs := []; 

	rel := RelativeOrders(coll); 
	elms := []; 
	for i in [1 .. 100] do
		# generate random exponents x
		x := [];
		for k in [1 .. n] do # only take elements in normal form as input
			if rel[k] <> 0 then 
				Add(x, Random( [0 .. Minimum(lim, rel[k] - 1)] ) ); 
			else 
				Add(x, Random([-lim .. lim]));
			fi; 
		od; 
		Add(elms, x); 
	od; 
	elms_gr := List(elms, x -> PcpElementByExponents(coll, x)); 
	
	DTobj_r := DTpols_r(coll); 
	DTobj_rs := DTpols_rs(coll); 
	
	invcoll := function()
		for x in elms_gr do
			Add(invc, x^(-1) );
		od;
	end; 
	
	inv_r := function()
		for x in elms do
			Add(invr, InverseByDT(x, DTobj_r)); 
		od;
	end; 
	
	inv_rs := function()
		for x in elms do
			Add(invrs, InverseByDT(x, DTobj_rs)); 
		od;
	end; 
	
	avg_invcoll := Benchmark(invcoll, rec( maxreps := 5, minreps := 5, silent := true)).avg;
	avg_inv_r := Benchmark(inv_r, rec( maxreps := 5, minreps := 5, silent := true)).avg;
	avg_inv_rs := Benchmark(inv_rs, rec( maxreps := 5, minreps := 5, silent := true)).avg;
	
	invc := List(invc, x -> Exponents(x)); 
	if invc <> invr or invr <> invrs then 
		Error(); 
	fi; 
	
	return [avg_inv_r, avg_inv_rs, avg_invcoll]; 
end; 
# 
# p := 2;
# k := 9; 
# 
# for j in [1] do 
# 	num := NrSmallGroups(p^k); 
# 	Print("\n(p, k) = (", p, ", ", k, ")\n"); 
# 	nr := Random([1 .. num]); 
# 	Print(nr, "\n"); 
# 	G := SmallGroup(p^k, nr);
# 	H := PcGroupToPcpGroup(G);
# 	orderstab(H); 
# 
# 	num := NrSmallGroups(p^k); 
# 	Print("\n(p, k) = (", p, ", ", k, ")\n"); 
# 	nr := Random([1 .. num]); 
# 	nr := Random([1 .. num]); 
# 	Print(nr, "\n"); 
# 	G := SmallGroup(p^k, nr);
# 	H := PcGroupToPcpGroup(G);
# 	orderstab(H); 
# 	
# 	num := NrSmallGroups(p^k); 
# 	Print("\n(p, k) = (", p, ", ", k, ")\n"); 
# 	nr := Random([1 .. num]); 
# 	nr := Random([1 .. num]); 
# 	nr := Random([1 .. num]); 
# 	Print(nr, "\n"); 
# 	G := SmallGroup(p^k, nr);
# 	H := PcGroupToPcpGroup(G);
# 	orderstab(H); 
# 	
# 	num := NrSmallGroups(p^k); 
# 	Print("\n(p, k) = (", p, ", ", k, ")\n"); 
# 	nr := Random([1 .. num]); 
# 	nr := Random([1 .. num]); 
# 	nr := Random([1 .. num]); 
# 	nr := Random([1 .. num]); 
# 	Print(nr, "\n"); 
# 	G := SmallGroup(p^k, nr);
# 	H := PcGroupToPcpGroup(G);
# 	orderstab(H); 
# od; 
#  