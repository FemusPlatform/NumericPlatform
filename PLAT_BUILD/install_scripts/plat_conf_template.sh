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
MPI_BIN_PATH=$PLAT_DIR/PLAT_THIRD_PARTY/openmpi/bin/
if [ -d  "$MPI_BIN_PATH" ]; then
export PATH=$PLAT_DIR/PLAT_THIRD_PARTY/openmpi/bin/:$PATH
export LD_LIBRARY_PATH=$PLAT_DIR/PLAT_THIRD_PARTY/openmpi/lib64/:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$PLAT_DIR/PLAT_THIRD_PARTY/openmpi/lib/:$LD_LIBRARY_PATH
export MPI_BIN_PATH=$PLAT_DIR/PLAT_THIRD_PARTY/openmpi/bin/
export MPI_LIB_PATH=$PLAT_DIR/PLAT_THIRD_PARTY/openmpi/lib64/
echo "MPI   " LIB is installed: environment is set 
else
echo "MPI   " LIB  not installed 
fi

# petsc 
PETSC_DIR=$PLAT_DIR/PLAT_THIRD_PARTY/petsc
if [ -d  "$PETSC_DIR" ]; then
export PETSC_DIR=$PLAT_DIR/PLAT_THIRD_PARTY/petsc
export PETSC_ARCH=linux-opt
export LD_LIBRARY_PATH=$PETSC_DIR/lib/:$LD_LIBRARY_PATH
echo "PETSC " LIB is installed: environment is set 
else
echo "PETSC " LIB  not installed 
fi
# hdf5
HDF5_DIR=$PLAT_DIR/PLAT_THIRD_PARTY/hdf5
if [ -d  "$HDF5_DIR" ]; then
export HDF5_DIR=$PLAT_DIR/PLAT_THIRD_PARTY/hdf5
export HDF5_PATH=$PLAT_DIR/PLAT_THIRD_PARTY/hdf5
export LD_LIBRARY_PATH=$HDF5_PATH/lib:$LD_LIBRARY_PATH
export HDF5_DISABLE_VERSION_CHECK=1
echo "HDF5  " LIB is installed: environment is set 
else
echo "HDF5  " LIB  not installed 
fi
# med 
MED_COUPL_PATH=$PLAT_DIR/PLAT_THIRD_PARTY/MED_coupling
if [ -d  "$MED_COUPL_PATH" ]; then
export med_PATH=$PLAT_DIR/PLAT_THIRD_PARTY/med
export MED_PATH=$PLAT_DIR/PLAT_THIRD_PARTY/MED_mod
export MED_COUPL_PATH=$PLAT_DIR/PLAT_THIRD_PARTY/MED_coupling
export LD_LIBRARY_PATH=$med_PATH/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$MED_PATH/lib/salome:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$MED_COUPL_PATH/lib:$LD_LIBRARY_PATH
echo "MED   " LIB is installed: environment is set 
else
echo "MED   " LIB  not installed 
fi

# =====================================================
#                    LEVEL 2 - CODES
# =====================================================

# femus
FEMUS_DIR=$PLAT_DIR/PLAT_CODES/femus/
if [ -d  "$FEMUS_DIR" ]; then
export FEMUS_DIR=$PLAT_DIR/PLAT_CODES/femus/
export PATH=$FEMUS_DIR/bin/:$PATH
export PATH=$FEMUS_DIR/:$PATH
export LD_LIBRARY_PATH=$FEMUS_DIR/contrib/laspack:$LD_LIBRARY_PATH  #only for VOF
export LD_LIBRARY_PATH=$FEMUS_DIR/lib:$LD_LIBRARY_PATH  
source $FEMUS_DIR/femus.sh
echo "  "
echo "FEMUS  " code is installed: " environment is set (source PLAT_CODES/femus/femus.sh)" 
echo "                              available environment functions:"
echo "                                      femus_application_configure"
echo "                                      femus_show_compiling_functions"
echo "                                      femus_gencase_compile"
echo "                                      femus_show_application_functions"
echo "                                      femus_.........................."
echo "                                      $>femus_  tab -> to see the functions"
else 
echo "FEMUS  " code not installed 
fi


# libmesh
LIBMESH_PATH=$PLAT_DIR/PLAT_CODES/libmesh/
if [ -d "$LIBMESH_PATH" ]; then
export LIBMESH_PATH=$PLAT_DIR/PLAT_CODES/libmesh/
export LD_LIBRARY_PATH=$LIBMESH_PATH/lib64/:$LD_LIBRARY_PATH
echo "LIBMESH" code is installed: run examples 
else
echo "LIBMESH" code not installed 
fi
# openfoam
OF_PATH=$PLAT_DIR/PLAT_CODES/foam
if [ -d "$OF_PATH" ]; then
echo "OpFOAM " code is installed: please run fe40 to set env of  OpenFoam
else
echo "OpFOAM " code not installed 
fi

DD_PATH=$PLAT_DIR/PLAT_CODES/dragondonjon
if [ -d "$DD_PATH" ]; then
echo "DRDONJ " code is installed
else
echo "DRDONJ " code not installed 
fi

# CATHARE_PATH=$PLAT_DIR/PLAT_CODES/cathare
# if [ -d "$CATHARE_PATH" ]; then
# echo "CATHARE" code is installed: please run cat_conf.sh to set env of Cathare 
# else
# echo "CATHARE" code is not installed 
# fi

# =====================================================
#                    LEVEL 2 - VISU
# =====================================================

# Paraview with med
export PARAVIEW_LOADED=0
function platParaview () {
  if [ $PARAVIEW_LOADED == 0 ] ; then 
    source $PLAT_THIRD_PARTY_DIR/salome/salome_prerequisites.sh
    source $PLAT_THIRD_PARTY_DIR/salome/salome_modules.sh
    PARAVIEW_LOADED=1
  fi
    paraview &
}



