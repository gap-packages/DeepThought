DeclareCategory( "IsDTObj", IsFromTheLeftCollectorRep);
BindGlobal( "DTObjFamily", NewFamily("DTObjFamily") );
BindGlobal( "DTObjType", NewType(DTObjFamily, IsDTObj and IsPositionalObjectRep and IsMutable) );

# introduce new indices for collectors which are DTObj: 
BindGlobal( "PC_DTPPolynomials", 	31 );
BindGlobal( "PC_DTPOrders",     	32 );
BindGlobal( "PC_DTPConfluent",  	33 );