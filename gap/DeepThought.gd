#
# DeepThought: This package provides functions for multiplication and other computations in finitely generated nilpotent groups based on the Deep Thought algorithm.
#
# Declarations
#


# QUICK HACK: declare some functions to resolve circular dependencies
# on the long run, clean this up
DeclareGlobalFunction( "DTP_AreAlmostEqual" );

#! @Chapter The Deep Thought algorithm
#! Polycyclic and, especially, finitely generated nilpotent groups exhibit a rich structure allowing a special approach towards multiplication using polynomials. The so-called Deep Thought algorithm introduced by C. R. Leedham-Green and L. H. Soicher in "Symoblic Collection Using Deep Thought" (1998) computes these polynomials in practice for a suitable presentation of a finitely generated nilpotent group. Such a presentation is of the following form
#! 
#! $$ \langle a_1, \ldots, a_n \mid a_i^{s_i} = a_{i+1}^{c_{i, i, i+1}} \cdots a_n^{c_{i, i, n}}, a_j a_i = a_i a_j a_{j+1}^{c_{i, j, j+1}} \ldots a_n^{c_{i, j, n}}, 1 \leq i &lt; j \leq n \rangle $$
#! with $s_i \in \mathbb{N} \cup \{ \infty \}$ and $c_{i, j, k} \in \mathbb{Z}$. This presentation may or may not be consistent. However, if the presentation is not consistent, not all functions provided in this package are applicable, see function <C>DTP_DTapplicability</C>. 
#!<P/>
#! Let $G$ denote the group presented by the above presentation. Then every element in $G$ can be written uniquely in a so-called normal form. That is, if $G_i := \langle a_i, \ldots, a_n \rangle$ and  $r_i := | G_i : G_{i+1}|$, $1, \leq i \leq n$, are the relative orders, then each element can be written as 
#! $$ a_1^{e_1} \cdots a_n^{e_n} $$
#! with $0 \leq e_i &lt; r_i$ if $r_i &lt; \infty$. 
#!<P/>
#! The Deep Thought algorithm computes rational polynomials $f_1, \ldots, f_n$ in $2n$ indeterminates such that if $ x := a_1^{x_1} \cdots a_n^{x_n} $ and $y := a_1^{y_1} \cdots a_n^{y_n} $ are two elements in normal form, then the normal form of their product $xy$ is given by 
#! $$a_1^{f_1(x_1, \ldots, x_n, y_1, \ldots, y_n)} \cdots a_n^{f_n(x_1, \ldots, x_n, y_1, \ldots, y_n)}.$$ 
#! Moreover, there exists a second version of the Deep Thought algorithms which computes $n^2$ polynomials $f_{rs}$, $1 \leq r, s \leq n$, suitable for multiplications of the form 
#! $$(a_1^{x_1} \cdots a_n^{x_n}) \cdot a_s^{y_s} $$
#! for $1 \leq s \leq n$. Each general multiplication can be expressed using these special multiplications. Depending on the presentation, polynomials of one version may be more efficient for computations than the polynomials of the other version. For a suggestion on which polynomials to use for a given presentation, see the function <C>DTP_DTapplicability</C>. In the following, Deep Thought type $f_r$ refers to the Deep Though algorithm which uses $n$ polynomials and type $f_{rs}$ refers to the Deep Thought algorithm using $n^2$ polynomials. 
#!<P/>
#! In order to work with the Deep Thought functions, the group presentation is expected to be given as a collector <C>coll</C>, as defined in the &GAP; package Polycyclic. Moreover, the Polycyclic package introduces the structure of exponent vectors <C>expvec</C>, which will be used also in this package to represent group elements. 
#! In the following text, a group element $a_1^{x_1} \cdots a_n^{x_n}$ is identified with its exponent vector in form of the list <C>[x_1, ..., x_n]</C>. For example, if <C>expvec1, expvec2</C> are exponent vectors of elements in the same group, than <C>expvec1 * expvec2</C> describes the multiplication of the corresponding group elements, and so on. 
#!<P/>
#! This package uses lists with the name <C>DTobj</C> to store the Deep Though polynomials of a collector together with some additional information. That is, the functions <C>DTP_DTpols_r</C> and <C>DTP_DTpols_rs</C> return a list (<C>DTobj</C>) with four entries: 
#! <List>
#! <Item> <C>DTobj[1]</C>: collector <C>coll</C> which was input of the function</Item>
#! <Item> <C>DTobj[2]</C>: Deep Thought polynomials in form of (nested) lists</Item>
#! <Item> <C>DTobj[3]</C>: list containing orders of group generators</Item>
#! <Item> <C>DTobj[4]</C>: boolean value indicating whether the collector is consistent or not</Item>
#! </List>

#! @Chapter Using Deep Thought functions
#! In the following sections, functions provided for computing Deep Thought polynomials and using them for calculations are listed. 
#! @Section Computing Deep Though polynomials
	
#! @Arguments coll
#! @Returns boolean 
#! @Description Checks the collector <C>coll</C> for applicability of Deep Thought functions. Note that depending on consistency some functions may be applicable, while others are not. Information on the applicability and which type of Deep Thought polynomials are suggested is printed to the terminal. Here, "+" means that the following property is fulfilled, otherwise there is a "-". The function returns <C>false</C> if Deep Thought is not applicable to the collector <C>coll</C> and <C>true</C> otherwise. Anyway, even if <C>true</C> is returned, **not all functions need to be applicable** (in case of inconsistenies).  
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
DeclareGlobalFunction( "DTP_SolveEquation" ); 


#! @Section Accessing Deep Thought polynomials 
#! 	In this sections, functions which can be used to display a <C>DTobj</C>, or the Deep Thought polynomials only, are documented. Furthermore, Deep Thought polynomials stored in a <C>DTobj</C> can be converted to &GAP; polynomials.

#! @Arguments DTobj
#! @Returns void
#! @Description Prints information about <C>Dtobj</C> to the terminal. In particular, the Deep Thought polynomials are printed in human-readable form. 
DeclareGlobalFunction( "DTP_Display_DTobj" );

#! @Arguments f_r
#! @Returns void
#! @Description Prints the polynomials f_r computed by <C>DTP_DTpols_r</C> and stored in <C>DTobj[2]</C> to the terminal in a human-readable form.  
DeclareGlobalFunction( "DTP_Display_f_r" ); 

#! @Arguments f_rs
#! @Returns void
#! @Description Prints the polynomials f_rs computed by <C>DTP_DTpols_rs</C> and stored in <C>DTobj[2]</C> to the terminal in a human-readable form.
DeclareGlobalFunction( "DTP_Display_f_rs" ); 

#! @Arguments DTobj 
#! @Returns list
#! @Description Converts the Deep Thought polynomials stored in <C>DTobj[2]</C> to &GAP; polynomials and returns them in a list together with their polynomial ring.
DeclareGlobalFunction( "DTP_pols2GAPpols" ); 
