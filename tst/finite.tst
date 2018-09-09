gap> testpackage := Filename( DirectoriesPackageLibrary( "DeepThought", "tst" ),
>                             "testpackage.g" );;
gap> Read(testpackage);;

# finite group 
gap> p := 2;;
gap> k := 5;;
gap> num := NrSmallGroups(p^k);;
gap> nr := Random([1 .. num]);; 
gap> H := PcGroupToPcpGroup(SmallGroup(p^k, nr)); 
Pcp-group with orders [ 2, 2, 2, 2, 2 ]
gap> coll := Collector(H);;
gap> Test_DTP_functions(coll, true, 1000, 1000); 
true
gap> Test_DTP_functions(coll, false, 1000, 1000);
true
gap> Test_DTP_pkg_consistency(coll, 100);
true

# finite group 
gap> p := 2;;
gap> k := 8;;
gap> num := NrSmallGroups(p^k);;
gap> nr := Random([1 .. num]);; 
gap> H := PcGroupToPcpGroup(SmallGroup(p^k, nr)); 
Pcp-group with orders [ 2, 2, 2, 2, 2, 2, 2, 2 ]
gap> coll := Collector(H);;
gap> Test_DTP_functions(coll, true, 1000, 1000); 
true
gap> Test_DTP_functions(coll, false, 1000, 1000);
true
gap> Test_DTP_pkg_consistency(coll, 100);
true

# finite group 
gap> p := 5;;
gap> k := 2;;
gap> num := NrSmallGroups(p^k);;
gap> nr := Random([1 .. num]);; 
gap> H := PcGroupToPcpGroup(SmallGroup(p^k, nr)); 
Pcp-group with orders [ 5, 5 ]
gap> coll := Collector(H);;
gap> Test_DTP_functions(coll, true, 1000, 1000); 
true
gap> Test_DTP_functions(coll, false, 1000, 1000);
true
gap> Test_DTP_pkg_consistency(coll, 100);
true

# finite group 
gap> p := 5;;
gap> k := 4;;
gap> num := NrSmallGroups(p^k);;
gap> nr := Random([1 .. num]);; 
gap> H := PcGroupToPcpGroup(SmallGroup(p^k, nr)); 
Pcp-group with orders [ 5, 5, 5, 5 ]
gap> coll := Collector(H);;
gap> Test_DTP_functions(coll, true, 1000, 1000); 
true
gap> Test_DTP_functions(coll, false, 1000, 1000);
true
gap> Test_DTP_pkg_consistency(coll, 100);
true

# finite group 
gap> p := 7;;
gap> k := 3;;
gap> num := NrSmallGroups(p^k);;
gap> nr := Random([1 .. num]);; 
gap> H := PcGroupToPcpGroup(SmallGroup(p^k, nr)); 
Pcp-group with orders [ 7, 7, 7 ]
gap> coll := Collector(H);;
gap> Test_DTP_functions(coll, true, 1000, 1000); 
true
gap> Test_DTP_functions(coll, false, 1000, 1000);
true
gap> Test_DTP_pkg_consistency(coll, 100);
true

# finite group 
gap> p := 23;;
gap> k := 4;;
gap> num := NrSmallGroups(p^k);;
gap> nr := Random([1 .. num]);; 
gap> H := PcGroupToPcpGroup(SmallGroup(p^k, nr)); 
Pcp-group with orders [ 23, 23, 23, 23 ]
gap> coll := Collector(H);;
gap> Test_DTP_functions(coll, true, 1000, 1000); 
true
gap> Test_DTP_functions(coll, false, 1000, 1000);
true
gap> Test_DTP_pkg_consistency(coll, 100);
true
