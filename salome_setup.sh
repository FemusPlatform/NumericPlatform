#! /bin/bash

# exit on errors
set -e

mkdir -p PLAT_BUILD/packages_targz
cd PLAT_BUILD/packages_targz

wget -c https://files.salome-platform.org/Salome/Salome9.9.0/SALOME-9.9.0.tar.gz

cd ..
tar xvf packages_targz/SALOME-9.9.0.tar.gz

cd ..
mkdir -p PLAT_CODES
cd PLAT_CODES
ln -s ../PLAT_BUILD/SALOME-9.9.0 salome