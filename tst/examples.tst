gap> testpackage := Filename( DirectoriesPackageLibrary( "DeepThought", "tst" ),
>                             "testpackage.g" );;
gap> Read(testpackage);;
gap> coll :=  Collector(ExamplesOfSomePcpGroups(11));;
gap> Test_DTP_functions(coll, true, 50, 100);
true
gap> Test_DTP_functions(coll, false, 50, 100);
true
gap> Test_DTP_pkg_consistency(coll, 100);
true
gap> coll :=  Collector(ExamplesOfSomePcpGroups(12));;
gap> Test_DTP_functions(coll, true, 50, 50);
true
gap> Test_DTP_functions(coll, false, 50, 50);
true
gap> Test_DTP_pkg_consistency(coll, 100);
true
gap> coll :=  Collector(ExamplesOfSomePcpGroups(15));;
gap> Test_DTP_functions(coll, true, 10, 5);
true
gap> Test_DTP_functions(coll, false, 10, 5);
true
gap> coll :=  Collector(ExamplesOfSomePcpGroups(16));;
gap> Test_DTP_functions(coll, true, 10, 5);
true
gap> Test_DTP_functions(coll, false, 10, 5);
true
