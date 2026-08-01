This file describes changes in the DeepThought package.

## 1.0.10 (2026-08-01)

  - Drop the dependency on the GAPDoc package
  - Do not require the SmallGrp package for using DeepThought; it is now only
    needed for running the test suite
  - Update the CI setup

## 1.0.9 (2025-06-20)

  - Replace the obsolete `compiled.h` header by `gap_all.h` in the kernel
    extension
  - Fix the code coverage setup

## 1.0.8 (2025-01-03)

  - Modernize the kernel extension by using `GVAR_FUNC` and designated
    initializers for `StructInitInfo`
  - Fix the return value of the package `AvailabilityTest`
  - Test against GAP 4.14

## 1.0.7 (2024-08-27)

  - Use `LoadKernelExtension` and `IsKernelExtensionAvailable` to load the
    kernel extension, and raise the minimum GAP version to 4.12
  - Update the build system and maintainer contact details
  - Test against GAP 4.13 and with a minimal set of packages loaded

## 1.0.6 (2022-10-06)

  - Adjust the kernel extension `#include`s for recent GAP versions
  - Link to the MathJax version of the manual by default
  - Update the build system and the code coverage setup

## 1.0.5 (2021-04-05)

  - Add GPL-2.0-or-later license metadata

## 1.0.4 (2021-03-03)

  - Rename the package from `DeepThoughtPackage` to `DeepThought`

## 1.0.3 (2021-03-03)

  - Switch to a new build system
  - Add continuous integration via GitHub Actions
  - Update package metadata, authors, and repository information

## 1.0.2 (2018-09-13)

  - Update the package `AvailabilityTest` function
  - Make the test suite runnable from any location

## 1.0.1 (2018-08-24)

  - Fix restoring the kernel extension after loading a saved workspace
  - Restore compatibility with GAP 4.8 and older
  - Improve an error message and fix several typos
  - Update the build system

## 1.0.0 (2017-12-13)

  - Initial release
