DTP_orderstab := function(G, lim)
	local coll, n, elms, elms_gr, i, gens, gens_gr, DTObj_r, DTObj_rs, gen_coll, gen_r, gen_rs, x, elms_coll, elms_r, elms_rs, avg_gen_coll, avg_gen_r, avg_gen_rs, avg_elms_coll, avg_elms_r, avg_elms_rs, o_c, o_r, o_rs, rel, k, t;
	
	coll := Collector(G); 
	n := NumberOfGenerators(coll); 
	
	o_c := []; o_r := []; o_rs := []; 
	
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
	t := Runtime();
	elms_gr := List(elms, x -> PcpElementByExponents(coll, x)); 
	t := Runtime() - t; 
	Print(t, "\n"); 
	for i in [1..100] do if Exponents(elms_gr[i]) <> elms[i] then Print(i,"\n"); fi; od; 

	gens_gr := GeneratorsOfGroup(G); 
	gens := List(gens_gr, x -> Exponents(x)); 
	
	t := Runtime();
	DTObj_r := DTP_DTpols_r(coll); 
	DTObj_rs := DTP_DTpols_rs(coll); 
	t := Runtime() - t; 
	Print(t, "\n"); 
	
	gen_coll := function()
		for x in gens_gr do
			Add(o_c, Order(x));
		od;
	end; 
	
	gen_r := function()
		for x in gens do
			Add(o_r, DTP_Order(x, DTObj_r)); 
		od;
	end; 
	
	gen_rs := function()
		for x in gens do
			Add(o_rs, DTP_Order(x, DTObj_rs)); 
		od;
	end; 

	elms_coll := function()
		for x in elms_gr do
			Add(o_c, Order(x));
		od;
	end; 
	
	elms_r := function()
		for x in elms do
			Add(o_r, DTP_Order(x, DTObj_r)); 
		od;
	end; 
	
	elms_rs := function()
		for x in elms do
			Add(o_rs, DTP_Order(x, DTObj_rs)); 
		od;
	end; 
	
	avg_gen_coll := DTP_Benchmark(gen_coll, rec( maxreps := 5, minreps := 5, silent := true)).avg;
	avg_gen_r := DTP_Benchmark(gen_r, rec( maxreps := 5, minreps := 5, silent := true)).avg;
	avg_gen_rs := DTP_Benchmark(gen_rs, rec( maxreps := 5, minreps := 5, silent := true)).avg;
	
	if o_c <> o_r or o_r <> o_rs then 
		Error(); 
	fi; 
	
	avg_elms_coll := DTP_Benchmark(elms_coll, rec( maxreps := 5, minreps := 5, silent := true)).avg;
	avg_elms_r := DTP_Benchmark(elms_r, rec( maxreps := 5, minreps := 5, silent := true)).avg;
	avg_elms_rs := DTP_Benchmark(elms_rs, rec( maxreps := 5, minreps := 5, silent := true)).avg;

	if o_c <> o_r or o_r <> o_rs then 
		Error(); 
	fi; 
	
	return [avg_gen_r, avg_gen_rs, avg_gen_coll, avg_elms_r, avg_elms_rs, avg_elms_coll]; 
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
# 	DTP_orderstab(H); 
# 
# 	num := NrSmallGroups(p^k); 
# 	Print("\n(p, k) = (", p, ", ", k, ")\n"); 
# 	nr := Random([1 .. num]); 
# 	nr := Random([1 .. num]); 
# 	Print(nr, "\n"); 
# 	G := SmallGroup(p^k, nr);
# 	H := PcGroupToPcpGroup(G);
# 	DTP_orderstab(H); 
# 	
# 	num := NrSmallGroups(p^k); 
# 	Print("\n(p, k) = (", p, ", ", k, ")\n"); 
# 	nr := Random([1 .. num]); 
# 	nr := Random([1 .. num]); 
# 	nr := Random([1 .. num]); 
# 	Print(nr, "\n"); 
# 	G := SmallGroup(p^k, nr);
# 	H := PcGroupToPcpGroup(G);
# 	DTP_orderstab(H); 
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
# 	DTP_orderstab(H); 
# od; 
#  