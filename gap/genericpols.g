
# DTP_AreAlmostEqual C function

# DTP_SequenceLetter C function

# DTP_Seq_i C function

Read("left_of.g");
Read("letters.g");
Read("structure_letter.g");

DT_GenericPols_rs := function(n)
  local all_pols, s;
  # assume for all conjugate coefficients that c_{i,j,k} <> 0 and
  # consider them as indeterminates

  all_pols := [];
  # for every 1 <= s <= n compute the polynomials f_rs, 1 <= r <= n
  for s in [1 .. n] do
    Add(all_pols, DTP_DTpols_r_S(n, s));
  od;

  return all_pols;
end;

DT_GenericPols_r := function(n)
  local pols_f_r, reps, r, f_r, reps_r, alpha, g_alpha, term, added;

	pols_f_r := [];
	# compute reps_r for 1 <= r <= n
	reps := DTP_ComputeSetReps(coll, 0);

	# compute the polynomials
	for r in [1 .. n] do
		# compute polynomial f_r: f_r is list of summands
		# g_alpha as described in DTP_Polynomial_g_alpha
		f_r := [];
		reps_r := reps[r]; # = reps_r
		for alpha in reps_r do # for every representative in
		# reps_r compute the polynomial g_alpha
			# Check whether g_alpha is already contained in f_r.
			# If yes, add the constant factor of g_alpha to the
			# constant factor of term which is already contained.
			#
			# Note that we may simplify terms if they only differ
			# in their leading coefficient and we may compare polynomials
			# g_alpha by using
			#	"g_alpha1{[2 .. Length(g_alpha1)]} =
			#							g_alpha2{[2 .. Length(g_alpha2)]}"
			# since the entries are sorted by construction of g_alpha.
			g_alpha := DTP_Polynomial_g_alpha(alpha, coll);
			added := false;
			for term in [1 .. Length(f_r)] do
				if Length(f_r[term]) = Length(g_alpha) and f_r[term]{[2 .. Length(f_r[term])]} = g_alpha{[2 .. Length(g_alpha)]} then
					f_r[term][1] := f_r[term][1] + g_alpha[1];
					added := true;
					if f_r[term][1] = 0 then
						Remove(f_r, term);
					fi;
					break;
				fi;
			od;
			if not added then
				Add(f_r, g_alpha);
			fi;
		od;
		# add polynomial f_r to list pols_f_r
		Add(pols_f_r, f_r);
	od;

	# create DTObj:
	return DTP_FinalizeDTObj([], coll, pols_f_r, isConfl);

end;
