#
# DeepThought: This package provides functions for multiplication and other computations in finitely generated nilpotent groups based on the Deep Thought algorithm.
#
# Reading the declaration part of the package.
#

if not LoadKernelExtension("DeepThought") then
  Error("failed to load the DeepThought package kernel extension");
fi;

ReadPackage( "DeepThought", "gap/DTObj.gd");
ReadPackage( "DeepThought", "gap/DeepThought.gd");
