DeclareCategory( "IsDTObj", IsPolycyclicCollector );
BindGlobal( "DTObjFamily", NewFamily("DTObjFamily") );
BindGlobal( "DTObjType", NewType(DTObjFamily, IsDTObj and IsPositionalObjectRep and IsMutable) );

