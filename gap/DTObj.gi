InstallMethod( ViewObj,
    "for a DTObj",
    [ IsDTObj ],
function(dt)
    Print("<DTObj>");
end);

InstallMethod( Display, 
	"for a DTObj", 
	[ IsDTObj ], 
function(DTObj)
	DTP_Display_DTObj(DTObj); 
end); 

InstallMethod( CollectWordOrFail,
    "for a DTObj, an exponent vector, and gen-exp-pair",
    [ IsDTObj, IsList, IsList ],
function(DTObj, expvec, genexp)
	local multiply, b1, res, i, n, tmp, l; 
	Print("Here\n"); 
	if not IsBound(DTObj![PC_DTPPolynomials]) then 
		TryNextMethod(); 
	fi; 
	
	# CollectWordOrFail always returns normal forms, so the collector must
	# be confluent. 
	if not DTObj![PC_DTPConfluent] = true then 
		Error("Can not compute normal forms since the collector is not confluent. Use DTP_Multiply instead."); 
	fi; 
	
	# decide which polynomials were computed (either f_r or f_rs) for coll
	# in order to choose the correct multiplication function: 
	if IsInt(DTObj![PC_DTPPolynomials][1][1][1]) then 
		multiply := DTP_Multiply_r; 
	else
		multiply := DTP_Multiply_rs; 
	fi; 
	
	# genexp is of the form [gen1, exp1, gen2, exp2,...] where the generators
	# are not necessarily increasing, i.e. gen1 > gen2 possible. 
	# Need to compute corresponding reduced word of form 
	# gen1^exp1 * gen2^exp2 * ... and store the reduced word's exponents. 
	l := Length(genexp);
	n := NumberOfGenerators(DTObj); 
	b1 := 0 * [1 .. n]; 
	b1[genexp[1]] := genexp[2]; 
	for i in [2 .. l/2] do 
		tmp := 0 * [1 .. n];
		tmp[genexp[2 * i - 1]] := genexp[2 * i]; 
		b1 := multiply(b1, tmp, DTObj); 	
	od;

	res := multiply(expvec, b1, DTObj); 
	
	# the result of the multiplication is stored in a: 
	for i in [1 .. Length(expvec)] do 
		expvec[i] := res[i]; 
	od; 

	return true; 
end);

InstallMethod( UpdatePolycyclicCollector,
        "for a DTObj",
        [ IsDTObj ],
function( DTObj )
	local f_r, res; 
	
	# same code as for FromTheLeftCollector in collect.gi package Polycyclic:
	# TODO Can the method be called directly s.t. the code doesn't need to
	# be copied into this method?
    if not IsPolycyclicPresentation( DTObj ) then
       Error("the input presentation is not a polcyclic presentation");
    fi;

    FromTheLeftCollector_SetCommute( DTObj );

    ## We have to declare the collector up to date now because the following
    ## functions need to collect and are careful enough.
    SetFilterObj( DTObj, IsUpToDatePolycyclicCollector );

    FromTheLeftCollector_CompleteConjugate( DTObj );
    FromTheLeftCollector_CompletePowers( DTObj );

    if IsWeightedCollector( DTObj ) then
        FromTheLeftCollector_SetNilpotentCommute( DTObj );
    fi;
    
    # f_r = true <=> polynomials f_r were computed initally
    f_r := IsInt(DTObj![PC_DTPPolynomials][1][1][1]);
    
    # delete old DT data: 
    Unbind(DTObj![PC_DTPPolynomials]); 
    Unbind(DTObj![PC_DTPOrders]); 
    Unbind(DTObj![PC_DTPConfluent]); 
    
    # Now update Deep Thought polynomials, for this determine which
    # type of polynomials were computed initally: 
    if f_r then 
		# version f_r
		res := DTP_DTObjFromCollector(DTObj, false); 
	else
		# version f_rs 
		res := DTP_DTObjFromCollector(DTObj); 
	fi; 
	
	DTObj![PC_DTPPolynomials] := res![PC_DTPPolynomials]; 
	DTObj![PC_DTPOrders] := res![PC_DTPOrders]; 
	DTObj![PC_DTPConfluent] := res![PC_DTPConfluent]; 
end );

coll_paper := FromTheLeftCollector(4);
SetConjugate(coll_paper, 2, 1, [2, 1, 3, 2]);
SetConjugate(coll_paper, 3, 1, [3, 1, 4, 1]);
SetConjugate(coll_paper, 3, 2, [3, 1, 4, 5]);
UpdatePolycyclicCollector(coll_paper);
IsConfluent(coll_paper); 

Read("examples/ex_colls.g");
Read("examples/test.g"); 