#
# DeepThought: This package provides functions for multiplication and other computations in finitely generated nilpotent groups based on the Deep Thought algorithm.
#
# This file contains package meta data. For additional information on
# the meaning and correct usage of these fields, please consult the
# manual of the "Example" package as well as the comments in its
# PackageInfo.g file.
#
SetPackageInfo( rec(

PackageName := "DeepThought",
Subtitle := "This package provides functions for computations in finitely generated nilpotent groups based on the Deep Thought algorithm.",
Version := "1.0.6",
Date := "06/10/2022", # dd/mm/yyyy format
License := "GPL-2.0-or-later",

Persons := [
  rec(
    IsAuthor		:= true,
    IsMaintainer 	:= false,
    FirstNames 		:= "Nina",
    LastName 		:= "Wagner",
    Email 		:= "github@n-i-n-a.de",
  ),
  rec(
    LastName      := "Horn",
    FirstNames    := "Max",
    IsAuthor      := false,
    IsMaintainer  := true,
    Email         := "horn@mathematik.uni-kl.de",
    WWWHome       := "https://www.quendi.de/math",
    PostalAddress := Concatenation(
                       "Fachbereich Mathematik\n",
                       "TU Kaiserslautern\n",
                       "Gottlieb-Daimler-Straße 48\n",
                       "67663 Kaiserslautern\n",
                       "Germany" ),
    Place         := "Kaiserslautern, Germany",
    Institution   := "TU Kaiserslautern"
  ),
],

SourceRepository := rec(
    Type := "git",
    URL := "https://github.com/gap-packages/DeepThought",
),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
PackageWWWHome  := "https://gap-packages.github.io/DeepThought/",
PackageInfoURL  := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),
README_URL      := Concatenation( ~.PackageWWWHome, "README.md" ),
ArchiveURL      := Concatenation( ~.SourceRepository.URL,
                                 "/releases/download/v", ~.Version,
                                 "/", ~.PackageName, "-", ~.Version ),

ArchiveFormats := ".tar.gz",

##  Status information. Currently the following cases are recognized:
##    "accepted"      for successfully refereed packages
##    "submitted"     for packages submitted for the refereeing
##    "deposited"     for packages for which the GAP developers agreed
##                    to distribute them with the core GAP system
##    "dev"           for development versions of packages
##    "other"         for all other packages
##
Status := "deposited",

AbstractHTML   := "This package provides functions for computations in finitely generated nilpotent groups based on the Deep Thought algorithm.",

PackageDoc := rec(
  BookName  := "DeepThought",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0_mj.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "This package provides functions for multiplication and other computations in finitely generated nilpotent groups based on the Deep Thought algorithm.",
),

Dependencies := rec(
  GAP := ">= 4.9",
  NeededOtherPackages := [
    [ "GAPDoc", ">= 1.5" ],
    [ "polycyclic", ">= 2.11" ],
  ],
  SuggestedOtherPackages := [ ],
  ExternalConditions := [ ],
),

AvailabilityTest := function()
  local path, file;
  # the file below must exist for this package to work
  path := DirectoriesPackagePrograms("DeepThought");
  file := Filename(path, "DeepThought.so");
  return file <> fail;
end,

TestFile := "tst/testall.g",

Keywords := [ "Deep Thought", "finitely generated nilpotent groups", "Hall polynomials" ],

));
