gap> testpackage := Filename( DirectoriesPackageLibrary( "DeepThought", "tst" ),
>                             "testpackage.g" );;
gap> Read(testpackage);;

# test first collector 
gap> coll := FromTheLeftCollector(4);;
gap> SetConjugate(coll, 2, 1, [2, 1, 3, 2]);;
gap> SetConjugate(coll, 3, 1, [3, 1, 4, 1]);;
gap> SetConjugate(coll, 3, 2, [3, 1, 4, 5]);;
gap> UpdatePolycyclicCollector(coll);;
gap> Test_DTP_functions(coll, true, 100, 500);
true
gap> Test_DTP_functions(coll, false, 100, 500); 
true
gap> Test_DTP_pkg_consistency(DTP_rand_coll(), 100);
true

# test finite group
gap> coll := FromTheLeftCollector(3);;
gap> SetRelativeOrder(coll, 1, 15);;
gap> SetRelativeOrder(coll, 2, 10);;
gap> SetRelativeOrder(coll, 3, 3);;
gap> UpdatePolycyclicCollector(coll);;
gap> Test_DTP_functions(coll, true, 100, 500);
true
gap> Test_DTP_functions(coll, false, 100, 500); 
true
gap> Test_DTP_pkg_consistency(DTP_rand_coll(), 100);
true

# test cyclic group 
gap> coll := FromTheLeftCollector(1);;
gap> SetRelativeOrder(coll, 1, 3628800);;
gap> UpdatePolycyclicCollector(coll);;
gap> Test_DTP_functions(coll, true, 100, 1000);
true
gap> Test_DTP_functions(coll, false, 100, 1000); 
true
gap> Test_DTP_pkg_consistency(DTP_rand_coll(), 100);
true
