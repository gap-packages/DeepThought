#
# DeepThought: This package provides functions for multiplication and other computations in finitely generated nilpotent groups based on the Deep Thought algorithm.
#
# Declarations
#


# QUICK HACK: declare some functions to resolve circular dependencies
# on the long run, clean this up
DeclareGlobalFunction( "DTP_AreAlmostEqual" );

#! @Chapter Deep Thought
#! TODO Introduction DT algo. Explain polynomials of type $f_r$, $f_{rs}$. Explain notations, such as <C>exponent vector, coll, DTobj, f_r, f_rs</C>. Explain exponent vectors are identified with their corresponding elements in the following text. 

#! @Section Computing Deep Though polynomials

#! @Arguments coll
#! @Returns boolean 
#! @Description Checks the collector <C>coll</C> for applicability of Deep Thought functions. Note that depending on consistency some functions may be applicable, while others are not. Information on the applicability and which type of Deep Thought polynomials are suggested is printed to the terminal. Here, "+" means that the following property is fulfilled, otherwise there is a "-". The function returns <C>false</C> if Deep Thought is not applicable to the collector <C>coll</C> and <C>true</C> otherwise. Anyway, even if <C>true</C> is returned, **not all functions need to be applicable** (in case of inconsistencies).  
DeclareGlobalFunction( "DTP_DTapplicability" ); 

#! @Arguments coll, [, isConfl]
#! @Returns a list of type <C>DTobj</C>
#! @Description Computes the Deep Thought polynomials of type $f_r$ and stores them in <C>DTobj</C>. The optional argument <C>isConfl</C> is a boolean value. If <C>isConfl = false</C>, then the collector <C>coll</C> is supposed to be not consistent. When using the returned <C>DTobj</C> for multiplication, the results are returned as reduced words which are not necessarily in normal form. If <C>isConfl</C> is not provided or <C>isConlf = true</C>, the collector is assumed to be consistent and results returned in computations are in normal form, unless otherwise stated. 
DeclareGlobalFunction( "DTP_DTpols_r" );

#! @Arguments coll, [, isConfl]
#! @Returns a list of type <C>DTobj</C>
#! @Description Computes the Deep Thought polynomials of type $f_{rs}$ and stores them in <C>DTobj</C>. The optional argument <C>isConfl</C> is a boolean value. If <C>isConfl = false</C>, then the collector <C>coll</C> is supposed to be not consistent. When using the returned <C>DTobj</C> for multiplication, the results are returned as reduced words which are not necessarily in normal form. If <C>isConfl</C> is not provided or <C>isConlf = true</C>, the collector is assumed to be consistent and results returned in computations are in normal form, unless otherwise stated. 
DeclareGlobalFunction( "DTP_DTpols_rs" );

#! @Section Computations with Deep Thought polynomials

#! @Arguments expvec, int, DTobj
#! @Returns an exponent vector
#! @Description Computes the exponent vector of <C>expvec</C>$^{int}$. If <C>DTobj[4] = true</C>, then the result is in normal form. 
DeclareGlobalFunction( "DTP_Exp" ); 

#! @Arguments expvec, DTobj
#! @Returns an exponent vector 
#! @Description Computes the exponent vector of the inverse of the element corresponding to <C>expvec</C>. If <C>DTobj[4] = true</C>, then the result describes a normal form.   
DeclareGlobalFunction( "DTP_Inverse" ); 

#! @Arguments expvec, coll
#! @Returns boolean or positive integer
#! @Description Checks whether <C>expvec</C> describes a normal form or not. If yes, the return value is <C>true</C>. Otherwise the return value is the smallest generator index for which the normal form condition is violated, i.e. for which the relative order <C>RelativeOrder(coll)[i]</C> is non-zero, and <C>expvec[i]</C> &lt; <C>0</C> or <C>expvec[i]</C> $\geq$ <C>RelativeOrder(coll)[i]</C>.  
DeclareGlobalFunction( "DTP_IsInNormalForm" ); 


#! @Arguments expvec1, expvec2, DTobj 
#! @Returns an exponent vector
#! @Description Computes the exponent vector of the product <C> expvec1 * expvec2 </C> using the Deep Thought polynomials of type $f_r$. If <C>DTobj[4] = true</C>, then the result is returned in normal form. 
DeclareGlobalFunction( "DTP_Multiply_r" ); 

#! @Arguments expvec1, expvec2, DTobj 
#! @Returns an exponent vector
#! @Description Computes the exponent vector of the product <C> expvec1 * expvec2 </C> using the Deep Thought polynomials of type $f_{rs}$. If <C>DTobj[4] = true</C>, then the result is returned in normal form. 
DeclareGlobalFunction( "DTP_Multiply_rs" ); 

#! @Arguments expvec, DTobj
#! @Returns an exponent vector
#! @Description Computes the exponent vector of the normal form of <C>expvec</C>. 
DeclareGlobalFunction( "DTP_NormalForm" );

#! @Arguments expvec, DTobj
#! @Returns positive integer or infinity 
#! @Description Computes the order of the element described by <C>expvec</C>. 
DeclareGlobalFunction( "DTP_Order" );

#! @Arguments expvec1, expvec2, DTobj
#! @Returns an exponent vector 
#! @Description Computes the exponent vector of the element corresponding to <C>expvec1</C>$^{-1}$ <C>* expvec2</C>, i.e. the result solves the equation <C>expvec1 * result = expvec2</C>. If <C>DTobj[4] = true</C>, then the result 
#! describes a normal form.  
#! @ChapterInfo Deep Thought, Applications 
DeclareGlobalFunction( "DTP_SolveEquation" ); 


#! @Section Accessing the Deep Thought polynomials 
#! 	In this sections, functions which can be used to display a <C>DTobj</C>, or the Deep Thought polynomials only, are documented. TODO Furthermore, Deep Thought polynomials stored in a <C>DTobj</C> can be converted to &GAP; polynomials.

#! @Arguments DTobj
#! @Description Prints information about <C>Dtobj</C> to the terminal. In particular, the Deep Thought polynomials are printed in human-readable form. 
DeclareGlobalFunction( "DTP_Display_DTobj" );

#! @Arguments f_r
#! @Description Prints the polynomials f_r computed by <C>DTP_DTpols_r</C> and stored in <C>DTobj[2]</C> to the terminal in a human-readable form.  
DeclareGlobalFunction( "DTP_Display_f_r" ); 

#! @Arguments f_rs
#! @Description Prints the polynomials f_rs computed by <C>DTP_DTpols_rs</C> and stored in <C>DTobj[2]</C> to the terminal in a human-readable form.
DeclareGlobalFunction( "DTP_Display_f_rs" ); 

