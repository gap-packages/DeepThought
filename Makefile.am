#
# DeepThought: This package provides functions for multiplication and other computations in finitely generated nilpotent groups based on the Deep Thought algorithm.
#
# This file is part of the build system of a GAP kernel extension.
# Requires automake.
#
ACLOCAL_AMFLAGS = -I m4

BINARCHDIR = bin/$(GAPARCH)
GAPINSTALLLIB = $(BINARCHDIR)/DeepThought.so

lib_LTLIBRARIES = DeepThought.la

DeepThought_la_SOURCES = src/DeepThought.c
DeepThought_la_CPPFLAGS = $(GAP_CPPFLAGS)
DeepThought_la_CFLAGS = $(GAP_CFLAGS)
DeepThought_la_LDFLAGS = $(GAP_LDFLAGS) -module -avoid-version
if SYS_IS_CYGWIN
DeepThought_la_LDFLAGS += -no-undefined -version-info 0:0:0 
DeepThought_la_LDFLAGS += -Wl,$(GAPROOT)/bin/$(GAPARCH)/gap.dll
endif

all-local: $(GAPINSTALLLIB)

$(GAPINSTALLLIB): DeepThought.la
	$(mkdir_p) $(BINARCHDIR)
if SYS_IS_CYGWIN
	cp .libs/DeepThought.dll $(GAPINSTALLLIB)
else
	cp .libs/DeepThought.so $(GAPINSTALLLIB)
endif

clean-local:
	rm -f $(GAPINSTALLLIB)

distclean-local:
	rm -rf bin/*

doc:
	($(GAPROOT)/bin/gap.sh -A makedoc.g)
