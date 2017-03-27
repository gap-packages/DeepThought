# example taken from paper
coll_paper := FromTheLeftCollector(4);
SetConjugate(coll_paper, 2, 1, [2, 1, 3, 2]);
SetConjugate(coll_paper, 3, 1, [3, 1, 4, 1]);
SetConjugate(coll_paper, 3, 2, [3, 1, 4, 5]);
UpdatePolycyclicCollector(coll_paper);

coll_example := FromTheLeftCollector(4);
SetConjugate(coll_example, 2, 1, [2, 1, 3, 2]);
SetConjugate(coll_example, 3, 1, [3, 1, 4, 1]);
SetConjugate(coll_example, 3, 2, [3, 1, 4, 5]);
SetRelativeOrder(coll_example, 1, 300); 
UpdatePolycyclicCollector(coll_example);

coll_thesis := FromTheLeftCollector(3);
SetConjugate(coll_thesis, 2, 1, [2, 1, 3, 3]); 
UpdatePolycyclicCollector(coll_thesis);

coll_finite := FromTheLeftCollector(3);
SetRelativeOrder(coll_finite, 1, 15);
SetRelativeOrder(coll_finite, 2, 10);
SetRelativeOrder(coll_finite, 3, 3); 
UpdatePolycyclicCollector(coll_finite);

coll_cyclic := FromTheLeftCollector(1);
SetRelativeOrder(coll_cyclic, 1, 3628800);
UpdatePolycyclicCollector(coll_cyclic);

UT_3 := Collector(UnitriangularPcpGroup(3, 0));
UT_5 := Collector(UnitriangularPcpGroup(5, 0));
UT_10 := Collector(UnitriangularPcpGroup(10, 0));
#UT_15 := Collector(UnitriangularPcpGroup(15, 0));
#UT_20 := Collector(UnitriangularPcpGroup(20, 0)); 
# 
# UT_3 := Collector(UnitriangularPcpGroup(3, 2));
# UT_5 := Collector(UnitriangularPcpGroup(5, 2));
# UT_10 := Collector(UnitriangularPcpGroup(10, 2));
# UT_15 := Collector(UnitriangularPcpGroup(15, 2));
# UT_20 := Collector(UnitriangularPcpGroup(20, 2)); 

heisenberg_3 := Collector(HeisenbergPcpGroup(3));
heisenberg_7 := Collector(HeisenbergPcpGroup(7)); 
heisenberg_30 := Collector(HeisenbergPcpGroup(30)); 
heisenberg_50 := Collector(HeisenbergPcpGroup(50)); 
# heisenberg_100 := Collector(HeisenbergPcpGroup(100)); 

# BurdeGrunewaldPcpGroup(s, t)
# Nilpotent group of Hirsch length 11. 
# If s <> 0, then this group has no faithful 12-dim. linear representation. 
BG_01 := Collector(BurdeGrunewaldPcpGroup(0, 1)); 
BG_11 := Collector(BurdeGrunewaldPcpGroup(1, 1)); 
BG_09 := Collector(BurdeGrunewaldPcpGroup(0, 9)); 
BG_97 := Collector(BurdeGrunewaldPcpGroup(9, 7)); 

# the other "ExamplesOfSomePcpGroups" don't fulfill the conjugate relations 
ex11 := Collector(ExamplesOfSomePcpGroups(11));
ex12 := Collector(ExamplesOfSomePcpGroups(12));
ex14 := Collector(ExamplesOfSomePcpGroups(14)); 
ex15 := Collector(ExamplesOfSomePcpGroups(15)); 
ex16 := Collector(ExamplesOfSomePcpGroups(16)); 

# create a random collector as in EickEngel.g: 
rand_coll := function()
	local t123, t345, t124, t145, t234, t134, t245, t125, t135, t235, rand, factors, collector, n, i; 
	
	# one of these has to be 0 
	rand := Random(0, 1);
	if rand = 1 then 
		t123 := 0; 
		t345 := Random([-1000 .. 1000]); 
	else
		t123 := Random([-1000 .. 1000]); 
		t345 := 0;
	fi; 

	# t124 * t345 + t145 * t234 = t134 * t245
	t124 := Random([-1000 .. 1000]); 
	t145 := Random([-1000 .. 1000]);
	t234 := Random([-1000 .. 1000]);
	factors := Factors(t124 * t345 + t145 * t234);
	t134 := 1;
	t245 := 1;
	for i in [1 .. Length(factors)] do 
		if Random(0, 1) = 1 then 
			t134 := t134 * factors[i]; 
		else
			t245 := t245 * factors[i]; 
		fi; 
	od; 

	# can be chosen arbitrarily 
	t125 := Random([-1000 .. 1000]);
	t135 := Random([-1000 .. 1000]);
	t235 := Random([-1000 .. 1000]);

	n := 5; 
	collector := FromTheLeftCollector(n);
	SetConjugate(collector, 2, 1, [2, 1, 3, t123, 4, t124, 5, t125]);
	SetConjugate(collector, 3, 1, [3, 1, 4, t134, 5, t135]);
	SetConjugate(collector, 4, 1, [4, 1, 5, t145]); 
	SetConjugate(collector, 3, 2, [3, 1, 4, t234, 5, t235]);
	SetConjugate(collector, 4, 2, [4, 1, 5, t245]); 
	SetConjugate(collector, 4, 3, [4, 1, 5, t345]); 
	UpdatePolycyclicCollector(collector);
	
	return collector; 
end; 
