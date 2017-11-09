/*
 * DeepThought: This package provides functions for multiplication and other computations in finitely generated nilpotent groups based on the Deep Thought algorithm.
 */

#include "src/compiled.h"          /* GAP headers */

#define IS_INTPOS(obj)          (TNUM_OBJ(obj) == T_INTPOS)
#define IS_INTNEG(obj)          (TNUM_OBJ(obj) == T_INTNEG)
#define IS_LARGEINT(obj)        (IS_INTPOS(obj) || IS_INTNEG(obj))

#define IS_INT(obj)             (IS_INTOBJ(obj) || IS_LARGEINT(obj))

#define IS_NEGATIVE(obj)        (IS_INTOBJ(obj) ? ((Int)obj < 0) : IS_INTNEG(obj))
#define IS_POSITIVE(obj)        (IS_INTOBJ(obj) ? ((Int)obj > 1) : IS_INTPOS(obj))
#define IS_ODD(obj)             (IS_INTOBJ(obj) ? ((Int)obj & 4) : (VAL_LIMB0(obj) & 1))
#define IS_EVEN(obj)            (!IS_ODD(obj))


Obj DTP_Binomial(Obj self, Obj N, Obj K)
{
    // handle some special cases
    if (K == INTOBJ_INT(1)) // K=1 is the most frequent case for us, so check it first
        return N;

    // restrict input
    if (!IS_INT(N) || !IS_INT(K))
        return Fail;

    if (K == INTOBJ_INT(0))
        return INTOBJ_INT(1);
    if (IS_NEGATIVE(K))
        return INTOBJ_INT(0);

    // from now on, k >= 2

    if (K == N)
        return INTOBJ_INT(1);

    if (IS_NEGATIVE(N))
        return Fail;    // TODO: implement this (does it happen?)

    if (LtInt(N, K))
        return INTOBJ_INT(0);

    // We only support immediate integers for k. Anything else at this point
    // would lead to output that's far too big for storage anyway.
    if (!IS_INTOBJ(K))
        return Fail;

    Int k = INT_INTOBJ(K);
    Int i;
    Obj res = N;
    Int quot = 1;

    // "unroll" the first few operations, to avoid repeated divisions, while
    // hopefully keeping res small enough to be represented as an immediate
    // (if N wasn't too big)
    for (i = 2; i <= k && i <= 6; ++i) {
        N = DiffInt(N, INTOBJ_INT(1));
        res = ProdInt(res, N);
        quot *= i;
    }
    res = QuoInt(res, INTOBJ_INT(quot));

    // now the general case
    for (; i <= k; ++i) {
        N = DiffInt(N, INTOBJ_INT(1));
        res = ProdInt(res, N);
        res = QuoInt(res, INTOBJ_INT(i));
    }

    return res;
}


typedef Obj (* GVarFunc)(/*arguments*/);

#define GVAR_FUNC_TABLE_ENTRY(srcfile, name, nparam, params) \
  {#name, nparam, \
   params, \
   (GVarFunc)name, \
   srcfile ":Func" #name }

// Table of functions to export
static StructGVarFunc GVarFuncs [] = {
    GVAR_FUNC_TABLE_ENTRY("DeepThought.c", DTP_Binomial, 2, "n, k"),

	{ 0 } /* Finish with an empty entry */

};

/******************************************************************************
*F  InitKernel( <module> )  . . . . . . . . initialise kernel data structures
*/
static Int InitKernel( StructInitInfo *module )
{
    /* init filters and functions                                          */
    InitHdlrFuncsFromTable( GVarFuncs );

    /* return success                                                      */
    return 0;
}

/******************************************************************************
*F  InitLibrary( <module> ) . . . . . . .  initialise library data structures
*/
static Int InitLibrary( StructInitInfo *module )
{
    /* init filters and functions */
    InitGVarFuncsFromTable( GVarFuncs );

    /* return success                                                      */
    return 0;
}

/******************************************************************************
*F  InitInfopl()  . . . . . . . . . . . . . . . . . table of init functions
*/
static StructInitInfo module = {
 /* type        = */ MODULE_DYNAMIC,
 /* name        = */ "DeepThought",
 /* revision_c  = */ 0,
 /* revision_h  = */ 0,
 /* version     = */ 0,
 /* crc         = */ 0,
 /* initKernel  = */ InitKernel,
 /* initLibrary = */ InitLibrary,
 /* checkInit   = */ 0,
 /* preSave     = */ 0,
 /* postSave    = */ 0,
 /* postRestore = */ 0
};

StructInitInfo *Init__Dynamic( void )
{
    return &module;
}
