frfrs := function(coll)
	local n, dc, x, y, i, j, x_exp, y_exp, pol_r, pol_rs, avg_pol_r, avg_pol_rs, mult_r, mult_rs, avg_r, avg_rs, z, DTobj_r, DTobj_rs, dcfunction, avg_dc; 
	
	n := NumberOfGenerators(coll); 
	
	dcfunction := function()
		dc := DecisionCriterion(coll); 
	end; 
	
	avg_dc := Benchmark(dcfunction, rec( maxreps := 5, minreps := 5, silent := true)).avg;
	
	if dc then 
		dc := "rs"; 
	else
		dc := "r"; 
	fi; 
	
	x := []; 
	y := []; 
	for i in [1 .. 10] do
		x_exp := []; y_exp := []; 
		for j in [1 .. n] do
			Add(x_exp, Random([-1000 .. 1000]));  Add(y_exp, Random([-1000 .. 1000]));                          
		od; 
		Add(x, x_exp); Add(y, y_exp);                                             
	od;
	
	pol_r := function()
		DTobj_r := DTP_DTpols_r(coll); 
	end; 
	
	pol_rs := function()
		DTobj_rs := DTP_DTpols_rs(coll); 
	end; 
	
	avg_pol_r := Benchmark(pol_r, rec( maxreps := 2, minreps := 2, silent := true)).avg;
	avg_pol_rs := Benchmark(pol_rs, rec( maxreps := 5, minreps := 5, silent := true)).avg;
	
	mult_r := function()
		for x_exp in x do 
			for y_exp in y do
				z := DTP_Multiply_r(x_exp, y_exp, DTobj_r); 
			od;
		od; 
	end; 
	
	mult_rs := function()
		for x_exp in x do 
			for y_exp in y do
				z := DTP_Multiply_rs(x_exp, y_exp, DTobj_rs); 
			od;
		od;
	end; 
	
	avg_r := Benchmark(mult_r, rec( maxreps := 5, minreps := 5, silent := true)).avg;
	avg_rs := Benchmark(mult_rs, rec( maxreps := 5, minreps := 5, silent := true)).avg;
	
	return [avg_pol_r, avg_r, avg_pol_rs, avg_rs, avg_dc, dc]; 
end; 

# 
# for p in Primes do 
# 	for k in [ 2, 5, 9] do 
# 		num := NrSmallGroups(p^k); 
# 		Print("\n(p, k) = (", p, ", ", k, ")\n"); 
# 
# 		# since random generator is reseted by Benchmark
# 			nr := Random([1 .. num]); 
# 			Print(nr, "\n"); 
# 			G := SmallGroup(p^k, nr);
# 			H := PcGroupToPcpGroup(G);
# 			c := Collector(H); 
# 			Print(frfrs(c), "\n");   
# 			
# 			nr := Random([1 .. num]); 
# 			nr := Random([1 .. num]); 
# 			Print(nr, "\n"); 
# 			G := SmallGroup(p^k, nr);
# 			H := PcGroupToPcpGroup(G);
# 			c := Collector(H); 
# 			Print(frfrs(c), "\n");  
# 			
# 			nr := Random([1 .. num]); 
# 			nr := Random([1 .. num]); 
# 			nr := Random([1 .. num]); 
# 			Print(nr, "\n"); 
# 			G := SmallGroup(p^k, nr);
# 			H := PcGroupToPcpGroup(G);
# 			c := Collector(H); 
# 			Print(frfrs(c), "\n");  
# 	od;   
# od; 

# gap> DecideWhichPols(ex15);
# Number of generators: 13
# Coeff ( = 22) suggests f_rs.
# DecisionCriterion suggests f_rs.
#     Computation of f_r: 244
#     Computation of f_rs: 220
# Computing polynomials: use f_rs.
#     Multiplication with f_r: 7308
#     Multiplication with f_rs: 17478.4
# Multiplication: use f_r.
# [ pols, multi, coeff, dc ]
# [ true, false, true, true ]

# gap> DecideWhichPols(ex16);                                                                                     
# Number of generators: 17                                                                                        
# Coeff ( = 28) suggests f_rs.                                                                                    
# DecisionCriterion suggests f_rs.                                                                                
#     Computation of f_r: 692
#     Computation of f_rs: 324
# Computing polynomials: use f_rs.
#     Multiplication with f_r: 43413.60000000001
#     Multiplication with f_rs: 89372
# Multiplication: use f_r.
# [ pols, multi, coeff, dc ]
# [ true, false, true, true ]