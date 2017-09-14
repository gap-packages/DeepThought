InstallMethod( ViewObj,
    "for a DTObj",
    [ IsDTObj ],
function(dt)
    Print("<DTObj>");
end);


InstallMethod( CollectWordOrFail,
    "for a DTObj, an exponent vector, and gen-exp-pair",
    [ IsDTObj, IsList, IsList ],
function(DTObj, expvec, genexp)
	local multiply, b1, res, i; 
	
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

	# since multiply expects exponent vectors, transform genexp:
	b1 := ExponentsByObj(DTObj, genexp); 
	
	res := multiply(expvec, b1, DTObj); 
	
	# the result of the multiplication is stored in a: 
	for i in [1 .. Length(expvec)] do 
		expvec[i] := res[i]; 
	od; 
	return true; 
end);

InstallMethod( IsConfluent,
        "for a DTObj",
        [ IsDTObj ],
function( DTObj )
	# when computing DTP_DTObjFromCollector, the function IsConfluent for 
	# collector is called and the result is stored in the following variable:
	return DTObj![PC_DTPConfluent]; 
	
	# TODO Is this function also called when using UpdatePolycyclicCollector?
	# Then confluency is NOT checked for a changed DTObj and the old value
	# is taken. Call method for a collector instead?! 
end );

InstallMethod( UpdatePolycyclicCollector,
        "for a DTObj",
        [ IsDTObj ],
function( DTObj )
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
    
    # Additionally, update Deep Thought polynomials, for this determine which
    # type of polynomials were computed: 
    if IsInt(DTObj![PC_DTPPolynomials][1][1][1]) then 
		# version f_r
		DTObj := DTP_DTObjFromCollector(DTObj, false); 
	else
		# version f_rs 
		DTObj := DTP_DTObjFromCollector(DTObj); 
	fi; 
end );

coll_paper := FromTheLeftCollector(4);
SetConjugate(coll_paper, 2, 1, [2, 1, 3, 2]);
SetConjugate(coll_paper, 3, 1, [3, 1, 4, 1]);
SetConjugate(coll_paper, 3, 2, [3, 1, 4, 5]);
UpdatePolycyclicCollector(coll_paper);

Read("examples/ex_colls.g");
Read("examples/test.g"); 