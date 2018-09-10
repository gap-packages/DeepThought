gap> testpackage := Filename( DirectoriesPackageLibrary( "DeepThought", "tst" ),
>                             "testpackage.g" );;
gap> Read(testpackage);;
gap> coll := Collector(UnitriangularPcpGroup(3, 0));;
gap> Test_DTP_functions(coll, true, 300, 500);
true
gap> Test_DTP_functions(coll, false, 300, 500);
true
gap> Test_DTP_pkg_consistency(coll, 100);
true
gap> coll :=  Collector(UnitriangularPcpGroup(5, 0));;
gap> Test_DTP_functions(coll, true, 200, 100);
true
gap> Test_DTP_functions(coll, false, 200, 100); 
true
gap> Test_DTP_pkg_consistency(coll, 100);
true
