# How to make a DTObj:
#   dt := [ 1,2,3];
#   Objectify( DTObjType, dt );


InstallMethod( ViewObj,
    "for a DTObj",
    [ IsDTObj ],
function(dt)
    Print("<DTObj>");
end);


InstallMethod( CollectWordOrFail,
    "for a DTObj, an exponent vector, and gen-exp-pair",
    [ IsDTObj, IsList, IsList ],
function(dt, expvec, genexp)
    Error("TODO");
end);

InstallMethod( UpdatePolycyclicCollector,
    "for a DTObj",
    [ IsDTObj ],
function(dt)
    Print("TODO: implement UpdatePolycyclicCollector\n");
end);

InstallMethod( IsConfluent,
    "for a DTObj",
    [ IsDTObj ],
function(dt)
    # TODO: is this correct?
    return dt![4];
end);


# Step 1: change DTP_DTpols_r and DTP_DTpols_rs
#  to return a DTObj, i.e. use Objectify in them
#  (and perhaps rename them, e.g.:
#      DTObjFromCollector( coll, rs_flag )
#  where rs_flag indicates whether to generate r or rs polynomials

# format of the new DTObj:

# first, all entries are as in other collectors; i.e., you just copy the content
# of the given original collector, like this:
# 
# for i in [1..22] do
#   if IsBound(coll![i]) then
#     dt[i] := StructuralCopy(coll![i]);
#   fi;
# od;
# 
# Then store "your" data in the extra slots

# then go on...


# Step 2: Make it possible to use a DTObj to define a pcp group
#
# Try this to see what still needs to be done:
#  dt := Objectify( DTObjType, [1,2,3, true] );
#  PcpGroupByCollector(dt);
#
# e.g. install method for UpdatePolycyclicCollector...
#
#  this then needs a method for IsConfluent...

# ... and so on...

# alternatively, also look at the polycyclic source code to see
# what kind of methods you might need to implement...


