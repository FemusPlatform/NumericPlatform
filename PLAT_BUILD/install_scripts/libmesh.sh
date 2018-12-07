# #############################################################################
# Install LIBMESH with HDF5 - PETSC - OpenMPI
# --------------------------------------------------------------------------------------------------
# This file script should be placed inside .../platform/plat_installation ($BUILD_DIR) and 
# the tar.gz package in the packages_targz dir ($BUILD_DIR/packages_targz)
# --------------------------------------------------------------------------------------------------

export VERSION=$1

if [ $VERSION == ""  ]; then
  echo "ERROR: no version given for LIBMESH installation "
  echo "Re-run libmesh.sh installer with additional version parameter"
  break
fi

PKG_NAME=libmesh-$VERSION
PKG_DIR=$PKG_NAME;
TAR_DIR=packages_targz;
LOG_DIR=package_logs;
SCRIPT_NAME=libmesh
# utility functions -----------------------------------------------------------
red=`tput setaf 1`; bold=`tput bold `; green=`tput setaf 2`; reset=`tput sgr0`
 
cd ..
if [ -f "plat_conf.sh" ]; then
source plat_conf.sh

INSTALL_BUILD_TAR_DIR=$BUILD_DIR/$TAR_DIR
INSTALL_PLAT_LOG_DIR=$BUILD_DIR/$LOG_DIR
INSTALL_DIR=$PLAT_THIRD_PARTY_DIR
MY_PREFIX_DIR=$BUILD_DIR
INSTALL_PLAT_PKG_DIR=$PLAT_THIRD_PARTY_DIR/$PKG_NAME
INSTALL_BUILD_PKG_DIR=$BUILD_DIR/$PKG_NAME

echo " Getting the evironment Platform set up 1 Level directory from   plat_conf.sh script"                   
echo "-----------------------------------------------------------------------------------------"              
echo $SCRIPT_NAME ": 1c PLAT_DIR (platform or software or ...) is     = " $PLAT_DIR                           
echo                                                                                                          
echo $SCRIPT_NAME ": 1c BUILD dir (BUILD_DIR) is                      = " $BUILD_DIR                          
echo $SCRIPT_NAME ": 1c INSTALL_BUILD_TAR_DIR (package archive dir)   = " $INSTALL_BUILD_TAR_DIR              
echo $SCRIPT_NAME ": 1c INSTALL_PLAT_LOG_DIR  (log dir)               = " $INSTALL_PLAT_LOG_DIR               
echo                                                                                                          
echo $SCRIPT_NAME ": 1c PLAT_THIRD_PARTY_DIR  (third party code dir)  = " $PLAT_THIRD_PARTY_DIR               
echo $SCRIPT_NAME ": 1c PLAT_USERS_DIR  (users dir)                   = " $PLAT_USERS_DIR                     
echo $SCRIPT_NAME ": 1c PLAT_CODES_DIR  (codes dir)                   = " $PLAT_CODES_DIR                     
echo $SCRIPT_NAME ": 1c PLAT_VISU  (visualization dir)                = " $PLAT_VISU_DIR                      
echo $SCRIPT_NAME ": 1d MPI dependency: OPENMPI_DIR                   = " $INSTALL_DIR"/openmpi/"             
echo $SCRIPT_NAME ": 1d MPI dependency: PATH                          = "$INSTALL_DIR/"openmpi/bin/"          
echo $SCRIPT_NAME ": 1d MPI dependency: LD_LIBRARY_PATH               = "$INSTALL_DIR/"openmpi/lib/"  
echo $SCRIPT_NAME ": 1d PETSC_DIR                                     = "$PETSC_DIR          
echo $SCRIPT_NAME ": 1d PETSC_ARCH                                    = "$PETSC_ARCH                                                                                                 
echo "-----------------------------------------------------------------------------------------"              
 
 
cd $BUILD_DIR 

# 1d Add to the path the openmpi executables and libraries in order to compile petsc
export PATH=$INSTALL_DIR/openmpi/bin/:$PATH
export LD_LIBRARY_PATH=$INSTALL_DIR/openmpi/lib64/:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$INSTALL_DIR/openmpi/lib/:$LD_LIBRARY_PATH
export PETSC_ARCH=linux-opt
export PETSC_DIR=$INSTALL_DIR/petsc
# 1e HDF5 setup ---------------------------------------------------------------
export HDF5_DIR=$INSTALL_DIR/hdf5

echo ${SCRIPT_NAME} " 1d MPI dependency: PATH=           "$INSTALL_DIR/"openmpi/bin/"
echo ${SCRIPT_NAME} " 1d MPI dependency: LD_LIBRARY_PATH="$INSTALL_DIR/"openmpi/lib/"
echo ${SCRIPT_NAME} " 1d PETSC dependency: PETSC dir    =" $INSTALL_DIR/petsc
echo ${SCRIPT_NAME} " 1d HDF5 dependency: HDF5 dir      =:" $HDF5_DIR

# =============================================================================
# ======= 2 Install  Libmesh script  =============================================
# =============================================================================

cd $BUILD_DIR

#if dir  does not exit in PLAT_DIR
if [ ! -d $INSTALL_BUILD_PKG_DIR ];   then
# ----------------------------------------------------------------------------
# untar 
  echo; echo ${SCRIPT_NAME} ": 2 -> 2b configure-> 2c make-> 2d install"

  if [ $VERSION == 'latest' ]; then
    git clone git://github.com/libMesh/libmesh.git  $INSTALL_BUILD_PKG_DIR  
  else
    if [ ! -f $INSTALL_BUILD_TAR_DIR/${PKG_NAME}.tar.gz ]; then
      wget --progress=dot https://github.com/libMesh/libmesh/releases/download/v$VERSION/libmesh-$VERSION.tar.gz \
      2>&1 | grep "%" |  sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e  "s,\%,,g" \
      | dialog --gauge "Download Libmesh $VERSION" 10 100
      clear
      if [ $fast == 'no' ]; then 
        dialog --title "Done downloading" --msgbox "${PKG_NAME}.tar.gz dowloaded from https://github.com/libMesh/libmesh/releases/download/v$VERSION/libmesh-$VERSION.tar.gz " 10 50
        clear
      fi
        mv  ${PKG_NAME}.tar.gz    $INSTALL_BUILD_TAR_DIR/${PKG_NAME}.tar.gz
    fi
    if [ ! -d "$INSTALL_BUILD_TAR_DIR/$PKG_NAME" ]; then
      cd $BUILD_DIR
      echo " ............  extracting the file: " $BUILD_DIR/packages_targz/$PKG_NAME.tar.gz "  ..............."
      tar -xzvf "$INSTALL_BUILD_TAR_DIR/$PKG_NAME.tar.gz" 
      echo "............. done extracting ............................................"
    fi
  fi
    
  cd $INSTALL_BUILD_PKG_DIR

  echo ${SCRIPT_NAME} ": 2b starting configure command" 
  
  ./configure --prefix=$INSTALL_PLAT_PKG_DIR \
              --with-mpi-dir=$INSTALL_DIR/openmpi \
              --with-hdf5=$INSTALL_DIR/hdf5 \
              --with-methods="dbg opt" >& $INSTALL_PLAT_LOG_DIR/${SCRIPT_NAME}_config.log
              
  if [ "$?" != "0" ]; then echo -e "2b ${red}ERROR! Unable to configure, see the log${NC}"; fi

  echo ${SCRIPT_NAME} ": 2c Configuration ended, now compiling"
  make -j2 >& $INSTALL_PLAT_LOG_DIR/${SCRIPT_NAME}_compile.log
  if [ "$?" != "0" ]; then   echo -e " 2c ${red}ERROR! Unable to compile, see the log ${NC}";fi
 
  echo ${SCRIPT_NAME} ": 2d Compilation ended now installing"
  make install  >& $INSTALL_PLAT_LOG_DIR/${SCRIPT_NAME}_install.log
  if [ "$?" != "0" ]; then echo -e " 2e ${red}ERROR! Unable to install${NC}";fi

  echo ${SCRIPT_NAME} ": successfully installed! in " $INSTALL_PLAT_PKG_DIR
  
  # ----------------------------------------------------------------------------
else
echo;   echo ${SCRIPT_NAME} ": 2 No installation: only links"  
# ----------------------------------------------------------------------------
fi

  
# =========================================================================================================
# 3) Post install Libmesh script ==========================================================================
# =========================================================================================================

cd $BUILD_DIR
if [ "$?" != "0" ]; then   echo -e " 2e ${red}ERROR!  libmesh installation not available${NC}";  fi
echo; echo ${SCRIPT_NAME} " 3: "$PKG_NAME"  post install"; echo ${SCRIPT_NAME} " 3 script -> 3a liks "

# 3a links --------------------------------------------------------------------
if [ -d $INSTALL_PLAT_PKG_DIR/lib ]; then rm -r $INSTALL_PLAT_PKG_DIR/lib; echo "ln deleted";fi
ln -s $INSTALL_PLAT_PKG_DIR/lib64  $INSTALL_PLAT_PKG_DIR/lib; echo ${SCRIPT_NAME} " 3a ${SCRIPT_NAME} link lib "
echo ln -s $INSTALL_PLAT_PKG_DIR/lib64  $INSTALL_PLAT_PKG_DIR/lib; echo ${SCRIPT_NAME} " 3a ${SCRIPT_NAME} link lib "

if [ -d $INSTALL_DIR/libmesh ]; then rm -r $INSTALL_DIR/libmesh; echo "ln deleted"; fi
ln -s  $INSTALL_PLAT_PKG_DIR    $PLAT_THIRD_PARTY_DIR/libmesh; echo ${SCRIPT_NAME} " 3a link libmesh "
ln -s  $INSTALL_PLAT_PKG_DIR    $PLAT_CODES_DIR/libmesh; echo ${SCRIPT_NAME} " 3b link libmesh "

echo  ln -s  $INSTALL_PLAT_PKG_DIR    $PLAT_THIRD_PARTY_DIR/libmesh; echo ${SCRIPT_NAME} " 3a link libmesh "
echo  ln -s  $INSTALL_PLAT_PKG_DIR    $PLAT_CODES_DIR/libmesh; echo ${SCRIPT_NAME} " 3b link libmesh "

else

echo  " Wrong directory or enviromnent !!!!! look for plat_conf.sh generated by plaftorm.sh !!!!!!"

fi
