#
# DeepThought: This package provides functions for multiplication and other computations in finitely generated nilpotent groups based on the Deep Thought algorithm.
#
# Declarations
#

#! @Description
#!   Insert documentation for you function here
DeclareGlobalFunction( "DTP_Example" );



# QUICK HACK: declare some functions to resolve circular dependencies
# on the long run, clean this up
DeclareGlobalFunction( "DTP_AreAlmostEqual" );
DeclareGlobalFunction( "DTP_NormalForm" );
DeclareGlobalFunction( "DTP_Order" );
