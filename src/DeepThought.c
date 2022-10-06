//
// DeepThought: This package provides functions for multiplication and
// other computations in finitely generated nilpotent groups based on the
// Deep Thought algorithm.
//

#include "compiled.h"   // GAP headers

#define IS_INTPOS(obj)          (TNUM_OBJ(obj) == T_INTPOS)
#define IS_INTNEG(obj)          (TNUM_OBJ(obj) == T_INTNEG)
#define IS_LARGEINT(obj)        (IS_INTPOS(obj) || IS_INTNEG(obj))

#define IS_INT(obj)             (IS_INTOBJ(obj) || IS_LARGEINT(obj))

#define IS_NEGATIVE(obj)        (IS_INTOBJ(obj) ? ((Int)obj < 0) : IS_INTNEG(obj))
#define IS_POSITIVE(obj)        (IS_INTOBJ(obj) ? ((Int)obj > 1) : IS_INTPOS(obj))
#define IS_ODD(obj)             (IS_INTOBJ(obj) ? ((Int)obj & 4) : (VAL_LIMB0(obj) & 1))
#define IS_EVEN(obj)            (!IS_ODD(obj))

#ifdef IS_PREC_REP
// for compatibility with GAP <= 4.8
#define IS_PREC(x) IS_PREC_REP(x)
#endif

static UInt RNleft, RNright, RNlength, RNnum, RNside;


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

Obj DTP_SequenceLetter(Obj self, Obj letter, Obj seq)
{
    if (!IS_PREC(letter))
        ErrorMayQuit("DTP_SequenceLetter: <letter> must be a plain record (not a %s)",
                 (Int)TNAM_OBJ(letter), 0L);

    if (!IS_PLIST(seq))
        ErrorMayQuit("DTP_SequenceLetter: <seq> must be a plain list (not a %s)",
                 (Int)TNAM_OBJ(seq), 0L);

    if (IsbPRec(letter, RNleft))
        DTP_SequenceLetter(self, ElmPRec(letter, RNleft), seq);

    if (IsbPRec(letter, RNright))
        DTP_SequenceLetter(self, ElmPRec(letter, RNright), seq);

    UInt len = LEN_PLIST(seq);
    AssPlist(seq, len+1, letter);

    return 0;
}

Obj DTP_Seq_i(Obj self, Obj letter, Obj i)
{
    if (!IS_PREC(letter))
    ErrorMayQuit("DTP_Seq_I: <letter> must be a plain record (not a %s)",
             (Int)TNAM_OBJ(letter), 0L);
    
    if (!IS_INT(i))
    ErrorMayQuit("DTP_Seq_i: <i> must be an integer (not a %s)",
         (Int)TNAM_OBJ(letter), 0L);

    // We only support immediate integers for i. Anything else at this point
    // would lead to output that's far too big for storage anyway.
    if (!IS_INTOBJ(i))
        return Fail;

    while( ElmPRec(letter, RNlength) > i ){
        Obj left = ElmPRec(letter, RNleft);
        if( ElmPRec(left, RNlength) >= i )
        {
            letter = left;
        } else {
            i = DiffInt( i, ElmPRec(left, RNlength) );
            letter = ElmPRec(letter, RNright);
        }
    }

    if(ElmPRec(letter, RNlength) != i){
        ErrorMayQuit("DTP_Seq_i: Assertion failure, letter.l <> i", 0, 0);
    }

    return letter;
}

Obj DTP_AreAlmostEqual(Obj self, Obj letter1, Obj letter2)
{
    if (!IS_PREC(letter1))
    ErrorMayQuit("DTP_AreAlmostEqual: <letter1> must be a plain record (not a %s)",
             (Int)TNAM_OBJ(letter1), 0L);
  
    if (!IS_PREC(letter2))
    ErrorMayQuit("DTP_AreAlmostEqual: <letter2> must be a plain record (not a %s)",
             (Int)TNAM_OBJ(letter2), 0L);

    // We must have letter1.num = letter2.num
    // and both must have the same length
    if( !EQ( ElmPRec(letter1, RNnum), ElmPRec(letter2, RNnum) ) || 
    !EQ( ElmPRec(letter1, RNlength), ElmPRec(letter2, RNlength) ) )
    {
        return False;
    }

    // check whether both are atoms / non-atoms:
    UInt is_atom = IsbPRec(letter1, RNside); // 1 <=> letter1 is atom 
    if( is_atom == IsbPRec(letter2, RNside) ){
        if( is_atom == 1) // both are atoms
        {   
            if( EQ( ElmPRec(letter1, RNside), ElmPRec(letter2, RNside) ) ){
                return True;
            } else {
                return False;                
            } 

        } else { // both are non-atoms
            if( EQ( ElmPRec(letter1, RNleft), ElmPRec(letter2, RNleft) ) &&
                EQ( ElmPRec(letter1, RNright), ElmPRec(letter2, RNright) ) ){
                return True;                
            } else {
                return False;
            }
        }
    } else { // one is an atom, the other one a non-atom
        return False;
    } 
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
    GVAR_FUNC_TABLE_ENTRY("DeepThought.c", DTP_SequenceLetter, 2, "letter, seq"),
    GVAR_FUNC_TABLE_ENTRY("DeepThought.c", DTP_Seq_i, 2, "letter, i"),
    GVAR_FUNC_TABLE_ENTRY("DeepThought.c", DTP_AreAlmostEqual, 2, "letter1, letter2"),
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

static Int PostRestore( StructInitInfo *module )
{
    RNleft = RNamName("left");
    RNright = RNamName("right");
    RNlength = RNamName("l");
    RNnum = RNamName("num");
    RNside = RNamName("side");

    return 0;
}

/******************************************************************************
*F  InitLibrary( <module> ) . . . . . . .  initialise library data structures
*/
static Int InitLibrary( StructInitInfo *module )
{
    /* init filters and functions */
    InitGVarFuncsFromTable( GVarFuncs );

    PostRestore(module);

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
 /* postRestore = */ PostRestore
};

StructInitInfo *Init__Dynamic( void )
{
    return &module;
}
