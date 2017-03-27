LoadPackage("polycyclic"); 

# read all files containing DT code
Read("DT/letters.g"); 
Read("DT/left_of.g"); 
Read("DT/structure_letters.g");
Read("DT/least.g"); 
Read("DT/set_reps.g"); 
Read("DT/DTapplicability.g"); 
Read("DT/display.g");
Read("DT/applications.g");
Read("DT/multiplication.g"); # multiplication needs applications and vice versa... 
Read("DT/polynomials.g"); 


if not IsBound(read) then 
	Read("ex_colls.g"); # contains example collectors
	Read("bench.g"); # benchmark 
	read := 1; 
fi; 

Read("test.g"); 

