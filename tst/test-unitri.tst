gap> Read("tst/testpackage.g");;

gap> coll := Collector(UnitriangularPcpGroup(3, 0));;
gap> Test_DTP_functions(coll, true, 500, 500);
true
gap> Test_DTP_functions(coll, false, 500, 500);

gap> coll :=  Collector(UnitriangularPcpGroup(5, 0)), 100, 100],
gap> Test_DTP_functions(coll, true, 1000, 100);
true
gap> Test_DTP_functions(coll, false, 1000, 100); 