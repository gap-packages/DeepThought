#
# DeepThought: This package provides functions for multiplication and other computations in finitely generated nilpotent groups based on the Deep Thought algorithm.
#
# Reading the declaration part of the package.
#
_PATH_SO:=Filename(DirectoriesPackagePrograms("DeepThought"), "DeepThought.so");
if _PATH_SO <> fail then
    LoadDynamicModule(_PATH_SO);
fi;
Unbind(_PATH_SO);

ReadPackage( "DeepThought", "gap/DTObj.gd");
ReadPackage( "DeepThought", "gap/DeepThought.gd");
