gap> Read("tst/testpackage.g");;

# test random collector 
gap> Test_DTP_functions(DTP_rand_coll(), true, 100, 1000);
true
gap> Test_DTP_functions(DTP_rand_coll(), false, 100, 1000);
true

# test random collector 
gap> Test_DTP_functions(DTP_rand_coll(), true, 100, 1000);
true
gap> Test_DTP_functions(DTP_rand_coll(), false, 100, 1000);
true

# test random collector 
gap> Test_DTP_functions(DTP_rand_coll(), true, 50, 100);
true
gap> Test_DTP_functions(DTP_rand_coll(), false, 50, 100);
true

# test random collector 
gap> Test_DTP_functions(DTP_rand_coll(), true, 10, 100);
true
gap> Test_DTP_functions(DTP_rand_coll(), false, 10, 100);
true
