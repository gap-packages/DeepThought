gap> testpackage := Filename( DirectoriesPackageLibrary( "DeepThought", "tst" ),
>                             "testpackage.g" );;
gap> Read(testpackage);;
gap> coll := Collector(HeisenbergPcpGroup(3));;
gap> Test_DTP_functions(coll, true, 1000, 100);
true
gap> Test_DTP_functions(coll, false, 1000, 100); 
true
gap> Test_DTP_pkg_consistency(coll, 100);
true
gap> coll := Collector(HeisenbergPcpGroup(7));;
gap> Test_DTP_functions(coll, true, 300, 100);
true
gap> Test_DTP_functions(coll, false, 1000, 100);
true
gap> Test_DTP_pkg_consistency(coll, 100);
true
gap> coll := Collector(HeisenbergPcpGroup(30));;
gap> Test_DTP_functions(coll, true, 10, 10);
true
gap> Test_DTP_functions(coll, false, 10, 10);
true
gap> Test_DTP_pkg_consistency(coll, 50);
true
