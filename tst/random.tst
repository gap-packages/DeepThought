gap> testpackage := Filename( DirectoriesPackageLibrary( "DeepThought", "tst" ),
>                             "testpackage.g" );;
gap> Read(testpackage);;

# test random collector 
gap> Test_DTP_functions(DTP_rand_coll(), true, 100, 1000);
true
gap> Test_DTP_functions(DTP_rand_coll(), false, 100, 1000);
true
gap> Test_DTP_pkg_consistency(DTP_rand_coll(), 100);
true

# test random collector 
gap> Test_DTP_functions(DTP_rand_coll(), true, 100, 1000);
true
gap> Test_DTP_functions(DTP_rand_coll(), false, 100, 1000);
true
gap> Test_DTP_pkg_consistency(DTP_rand_coll(), 100);
true

# test random collector 
gap> Test_DTP_functions(DTP_rand_coll(), true, 50, 100);
true
gap> Test_DTP_functions(DTP_rand_coll(), false, 50, 100);
true
gap> Test_DTP_pkg_consistency(DTP_rand_coll(), 10);
true

# test random collector 
gap> Test_DTP_functions(DTP_rand_coll(), true, 10, 100);
true
gap> Test_DTP_functions(DTP_rand_coll(), false, 10, 100);
true
gap> Test_DTP_pkg_consistency(DTP_rand_coll(), 10);
true