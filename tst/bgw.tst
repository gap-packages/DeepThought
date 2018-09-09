gap> START_TEST( "Start highlevel tests" );
gap> testpackage := Filename( DirectoriesPackageLibrary( "DeepThought", "tst" ),
>                             "testpackage.g" );;
gap> Read(testpackage);;
gap> coll := Collector(BurdeGrunewaldPcpGroup(0, 1));;
gap> Test_DTP_functions(coll, true, 5, 10);
true
gap> Test_DTP_functions(coll, false, 5, 10);
true
gap> STOP_TEST( "highlevel.tst", 10000 );