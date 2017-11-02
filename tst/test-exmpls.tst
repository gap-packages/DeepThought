gap> Read("tst/testpackage.g");;
gap> coll :=  Collector(ExamplesOfSomePcpGroups(11));;
gap> Test_DTP_functions(coll, true, 100, 500);
true
gap> Test_DTP_functions(coll, false, 100, 500);
true
gap> coll :=  Collector(ExamplesOfSomePcpGroups(12));;
gap> Test_DTP_functions(coll, true, 100, 500);
true
gap> Test_DTP_functions(coll, false, 100, 50);
true
gap> coll :=  Collector(ExamplesOfSomePcpGroups(15));;
gap> Test_DTP_functions(coll, true, 10, 10);
true
gap> Test_DTP_functions(coll, false, 10, 10);
true
gap> coll :=  Collector(ExamplesOfSomePcpGroups(16));;
gap> Test_DTP_functions(coll, true, 10, 10);
true
gap> Test_DTP_functions(coll, false, 10, 10);
true
