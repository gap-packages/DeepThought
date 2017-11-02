gap> Read("tst/testpackage.g");;
gap> coll := Collector(BurdeGrunewaldPcpGroup(0, 1));;
gap> Test_DTP_functions(coll, true, 10, 10);
true
gap> Test_DTP_functions(coll, false, 10, 10);
true
gap> coll := Collector(BurdeGrunewaldPcpGroup(9, 7));;
gap> Test_DTP_functions(coll, true, 10, 10);
true
gap> Test_DTP_functions(coll, false, 10, 10);
true
