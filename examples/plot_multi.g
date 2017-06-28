# Call "DTP_PlotMulti" with arguments 
#	- collector call suitable for DT
#	- integer num which gives the number of multiplications being executed
#	- integer lim giving a max. value for the absolute value in exponent 
#		vectors
#	- string name for saving the results in files with name 
#		"output-"name"-res/params"
#	- boolean nf: If nf = true, then the input elements for
#		multiplication are in normal form. Otherwise they are not. 
#		The computed products are always in normal form.
#
# The function creates two files (output-"name"-params and output-"name"-res) 
# containing times needed for collection/multiplication with polynomials
# and which may be read in latex. 
# The parameter "lim" is increased by 1, then the function is called again 
# until the computation takes a certain time in average. 

# DTP_PlotMulti(UT_10, 100, 1, "ut10", true);


DTP_PlotMulti1 := function(DTobj_rs, DTobj_r, num, lim, res, name, time_pols_rs, time_pols_r, nf)
	local coll, n, i, j, rel,
	x, y, x_coll, y_coll, x_exp, y_exp, x_pcp, y_pcp, 
	multiply_pols_rs, multiply_pols_r, multiply_coll,
	z_rs, z_r, z_coll, 
	res_rs, res_r, res_coll, 
	str, out_str, line, file; 
	
	Print("Limit: ", lim, ", "); 
	coll := DTobj_rs[1];
	n := NumberOfGenerators(coll); 
	rel := RelativeOrders(coll); 
	# generate num random elements (in normal form) with exponent vectors' 
	# entries between -lim and lim 
	x := []; 
	y := []; 
	for i in [1 .. num] do
		x_exp := []; 
		y_exp := []; 
		for j in [1 .. n] do
			if nf and rel[j] <> 0 then # exponent vectors in normal form: 
				Add(x_exp, Random([0 .. Minimum(lim, rel[j] - 1)]));  
				Add(y_exp, Random([0 .. Minimum(lim, rel[j] - 1)]));       
			else 
				Add(x_exp, Random([-lim .. lim]));
				Add(y_exp, Random([-lim .. lim]));                          
			fi; 
		od; 
		Add(x, x_exp); 
		Add(y, y_exp);                                             
	od;
	
	x_pcp := List(x, x_exp -> PcpElementByExponents(coll, x_exp)); 
	y_pcp := List(y, y_exp -> PcpElementByExponents(coll, y_exp)); 
	
	z_rs := []; z_r := []; z_coll := []; z_wm := []; 

	multiply_pols_rs := function()
		for i in [1 .. num] do 
			Add(z_rs, DTP_Multiply_rs(x[i], y[i], DTobj_rs));
		od; 
	end; 
	
	multiply_pols_r := function()
		for i in [1 .. num] do 
			Add(z_r, DTP_Multiply_r(x[i], y[i], DTobj_r)); 
		od; 
	end; 

	# Since CollectPolycyclic(pcp, a, b) overwrites the vector "a", make 
	# copies before using it. (a = exp_vec, b = genexp)
	x_coll := StructuralCopy(x);   
	y_coll := List(y, i -> ObjByExponents(coll, i));
	
	multiply_coll := function()
		for i in [1 .. num] do
#			CollectPolycyclicGap(coll, x_coll[i], y_coll[i]);
			# !!! This multiplication uses wm's polynomials if they 
			# were already computed in this GAP session!!!
			Add(z_coll, x_pcp[i] * y_pcp[i]); 
		od;
	end; 

	# call DTP_Benchmark exactly five times with each function 

	Print("Polynomials f_rs... "); 
	res_rs := DTP_Benchmark(multiply_pols_rs, rec( maxreps := 5, minreps := 5, silent := true)); 
	
	Print("Polynomials f_r... "); 
	res_r := DTP_Benchmark(multiply_pols_r, rec( maxreps := 5, minreps := 5, silent := true));

	Print("Collection..."); 
	res_coll := DTP_Benchmark(multiply_coll, rec( maxreps := 5, minreps := 5, silent := true ));
	
	Print("\n"); 
	
	# If nf = true, check whether all results are equal
	# convert/copy results
#	z_coll := x_coll; 
	z_coll := List(z_coll, i -> Exponents(i)); 
	if nf then 
		if not (z_rs = z_r and z_r = z_coll) then
			Error("normal forms differ!\n"); 
		fi; 
	fi; 
	
	# save results
	Add(res, rec( lim := lim, avg_rs := res_rs.avg, avg_r := res_r.avg, avg_coll := res_coll.avg ) ); 
	
	if Length(res) < 50 then 
		DTP_PlotMulti1(DTobj_rs, DTobj_r, num, lim + 1, res, name, time_pols_rs, time_pols_r, nf);
	fi; 
	
	# write results to file
	file := Concatenation("plot//output-", name, "-res");
	PrintTo(file, "lim coll pols_rs pols-constr_rs pols_r pols-constr_r wm \n"); 
 	for line in res do
		AppendTo(file, line.lim, " "); 
		AppendTo(file, line.avg_coll, " ");
		AppendTo(file, line.avg_rs, " ");
		AppendTo(file, time_pols_rs + line.avg_rs, " ");
		AppendTo(file, line.avg_r, " ");

		AppendTo(file, time_pols_r + line.avg_r, " \n");
	od;
	
	return res; 
end; 

DTP_PlotMulti := function(coll, num, lim, name, nf)
	local res, DTobj_rs, DTobj_r, time_pols_rs, time_pols_r, compute_pols_rs, compute_pols_r, file; 
	
	compute_pols_rs := function()
		DTobj_rs := DTP_DTpols_rs(coll); 
	end; 
	
	compute_pols_r := function()
		DTobj_r := DTP_DTpols_r(coll); 
	end; 
	
	time_pols_rs := DTP_Benchmark(compute_pols_rs, rec( maxreps := 5, minreps := 5, silent := true)); 
	time_pols_r := DTP_Benchmark(compute_pols_r, rec( maxreps := 5, minreps := 5, silent := true)); 
	
	file := Concatenation("plot//output-", name, "-params");
	PrintTo(file, "num lim_start time_pols_rs time_pols_r \n"); 
	AppendTo(file, num, " "); 
	AppendTo(file, lim, " "); 
	AppendTo(file, time_pols_rs.avg, " ");
	AppendTo(file, time_pols_r.avg, "\n");
	
	return DTP_PlotMulti1(DTobj_rs, DTobj_r, num, lim, [], name, time_pols_rs.avg, time_pols_r.avg, nf);
end; 
