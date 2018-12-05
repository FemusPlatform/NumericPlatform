# NumericPlatform
Official repository of open-source code based Numerical Platform

The Numerical Platform has been developed as an environment where several numerical
codes can be run together, allowing to model complex physical phenomena on different
physical scales. 

The platform is organized into a hierarchical set of levels, namely
* Level 0: main level of the Numerical Platform where the different components are gathered
* Level 1: differentiation of Numerical Platform main components into:
  * PLAT_BUILD: level where installing scripts are gathered and components are built
  * PLAT_THIRD_PARTY: components needed to run the numerical codes
  * PLAT_CODES: the numerical codes
  * PLAT_VISU: software for post processing and data visualization
  * USERS: level where applications are run
* Level 2: differentiation of the main components. Up to now the following packages can be installed
  * PLAT_THIRD_PARTY: 
      [Salome platform](http://www.salome-platform.org/),
      [OpenMPI library](https://www.open-mpi.org/),
      [Petsc library](https://www.mcs.anl.gov/petsc/),
      [Libmesh code](http://libmesh.github.io/),
      [med data format library](http://www.salome-platform.org/user-section/about/med),
      [MedCoupling library](http://docs.salome-platform.org/latest/dev/MEDCoupling/index.html)
  * PLAT_CODES:
      FEMuS code,
      [OpenFOAM extend](https://openfoamwiki.net/index.php/Main_Page),
      [Dragon code](http://www.oecd-nea.org/tools/abstract/detail/uscd1234/),
      Donjon code
  * PLAT_VISU:
      Paraview, as Salome package
  
  This repository represents Level 0 and it can be used to perform a complete Numerical Platform installation from scratch
