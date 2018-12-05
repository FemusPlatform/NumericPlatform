# =====================================================
#                    LEVEL 0 - PLATFORM PATH
# =====================================================
export PLAT_DIR=


# =====================================================
#                    LEVEL 1 - PLATFORM STRUCTURE
# =====================================================

export BUILD_DIR=$PLAT_DIR/PLAT_BUILD
export PLAT_THIRD_PARTY_DIR=$PLAT_DIR/PLAT_THIRD_PARTY
export PLAT_USERS_DIR=$PLAT_DIR/PLAT_USERS
export PLAT_CODES_DIR=$PLAT_DIR/PLAT_CODES
export PLAT_VISU_DIR=$PLAT_DIR/PLAT_VISU


# =====================================================
#                    LEVEL 2 - THIRD PARTY
# =====================================================

# openmpi
export PATH=$PLAT_DIR/PLAT_THIRD_PARTY/openmpi/bin/:$PATH
export LD_LIBRARY_PATH=$PLAT_DIR/PLAT_THIRD_PARTY/openmpi/lib64/:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$PLAT_DIR/PLAT_THIRD_PARTY/openmpi/lib/:$LD_LIBRARY_PATH
export MPI_BIN_PATH=$PLAT_DIR/PLAT_THIRD_PARTY/openmpi/bin/
export MPI_LIB_PATH=$PLAT_DIR/PLAT_THIRD_PARTY/openmpi/lib64/

# petsc 
export PETSC_DIR=$PLAT_DIR/PLAT_THIRD_PARTY/petsc
export PETSC_ARCH=linux-opt
export LD_LIBRARY_PATH=$PETSC_DIR/lib/:$LD_LIBRARY_PATH

# hdf5
export HDF5_DIR=$PLAT_DIR/PLAT_THIRD_PARTY/hdf5
export HDF5_PATH=$PLAT_DIR/PLAT_THIRD_PARTY/hdf5
export LD_LIBRARY_PATH=$HDF5_PATH/lib:$LD_LIBRARY_PATH
export HDF5_DISABLE_VERSION_CHECK=1

# med 
export med_PATH=$PLAT_DIR/PLAT_THIRD_PARTY/med
export MED_PATH=$PLAT_DIR/PLAT_THIRD_PARTY/MED_mod
export MED_COUPL_PATH=$PLAT_DIR/PLAT_THIRD_PARTY/MED_coupling
export LD_LIBRARY_PATH=$med_PATH/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$MED_PATH/lib/salome:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$MED_COUPL_PATH/lib:$LD_LIBRARY_PATH


# =====================================================
#                    LEVEL 2 - CODES
# =====================================================

# femus
export FEMUS_DIR=$PLAT_DIR/PLAT_CODES/femus/
export PATH=$FEMUS_DIR/bin/:$PATH
export PATH=$FEMUS_DIR/:$PATH
export LD_LIBRARY_PATH=$FEMUS_DIR/contrib/laspack:$LD_LIBRARY_PATH  #only for VOF
export LD_LIBRARY_PATH=$FEMUS_DIR/lib:$LD_LIBRARY_PATH  

# libmesh
export LIBMESH_PATH=$PLAT_DIR/PLAT_CODES/libmesh/
export LD_LIBRARY_PATH=$LIBMESH_PATH/lib64/:$LD_LIBRARY_PATH

# openfoam
#fe40
