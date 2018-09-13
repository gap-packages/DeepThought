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
Version := "1.0.2",
Date := "13/09/2018", # dd/mm/yyyy format

Persons := [
  rec(
    IsAuthor		:= true,
    IsMaintainer 	:= true,
    FirstNames 		:= "Nina",
    LastName 		:= "Wagner",
    Email 			:= "nina.wagner@math.uni-giessen.de",
	PostalAddress 	:= Concatenation(
						"AG Algebra\n",
						"Mathematisches Institut\n",
						"Justus-Liebig-Universität Gießen\n",
						"Arndtstraße 2\n",
						"35392 Gießen\n",
						"Germany" ),
    Place         	:= "Gießen",
    Institution   	:= "Justus-Liebig-Universität Gießen"
  ),
  rec(
    LastName      := "Horn",
    FirstNames    := "Max",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "max.horn@math.uni-giessen.de",
    WWWHome       := "http://www.quendi.de/math",
    PostalAddress := Concatenation(
                       "AG Algebra\n",
                       "Mathematisches Institut\n",
                       "Justus-Liebig-Universität Gießen\n",
                       "Arndtstraße 2\n",
                       "35392 Gießen\n",
                       "Germany" ),
    Place         := "Gießen",
    Institution   := "Justus-Liebig-Universität Gießen"
  ),
],

SourceRepository := rec(
    Type := "git",
    URL := "https://github.com/duskydolphin/DeepThoughtPackage",
),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
SupportEmail   := "nina.wagner@math.uni-giessen.de",
PackageWWWHome  := "https://duskydolphin.github.io/DeepThoughtPackage/",
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
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "This package provides functions for multiplication and other computations in finitely generated nilpotent groups based on the Deep Thought algorithm.",
),

Dependencies := rec(
  GAP := ">= 4.8",
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
