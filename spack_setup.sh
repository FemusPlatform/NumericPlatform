#! /bin/bash

# exit on errors
set -e

# avoid problems with splitting lib and lib64
unset CONFIG_SITE

# check that spack is available
if ! command -v spack &> /dev/null
then
    echo "spack could not be found, please check your installation"
    exit 1
fi

# install the spack environment
spack env activate spack_env
spack install

# link packages in PLAT_THIRD_PARTY
mkdir -p PLAT_THIRD_PARTY

hdf5_dir=$(spack location -i hdf5)
echo "linking hdf5 from ${hdf5_dir}"
ln -s ${hdf5_dir} PLAT_THIRD_PARTY/hdf5

med_dir=$(spack location -i salome-med)
echo "linking med from ${med_dir}"
ln -s ${med_dir} PLAT_THIRD_PARTY/med

medcoupling_dir=$(spack location -i salome-medcoupling)
echo "linking medcoupling from ${medcoupling_dir}"
ln -s ${medcoupling_dir} PLAT_THIRD_PARTY/medcoupling

openmpi_dir=$(spack location -i openmpi)
echo "linking openmpi from ${openmpi_dir}"
ln -s ${openmpi_dir} PLAT_THIRD_PARTY/openmpi

petsc_dir=$(spack location -i petsc)
echo "linking medcoupling from ${petsc_dir}"
ln -s ${petsc_dir} PLAT_THIRD_PARTY/petsc

# link packages in PLAT_CODES
mkdir -p PLAT_CODES

libmesh_dir=$(spack location -i libmesh)
echo "linking medcoupling from ${libmesh_dir}"
ln -s ${libmesh_dir} PLAT_CODES/libmesh

