# #############################################################################
# INSTALL FEMUS CODE
# -----------------------------------------------------------------------------
# This file script should be placed inside .../platform/plat_installation ($BUILD_DIR) and 
# the tar.gz package in the packages_targz dir ($BUILD_DIR/packages_targz)
# -----------------------------------------------------------------------------
# #############################################################################

export PKG_NAME=lapack
SCRIPT_NAME=lapack
BUILD_DIR=$PWD
LOG_DIR=package_logs

cd ../                  # back to Numerical Platform main directory - Level 0
source plat_conf.sh     # set up environment

export LAPACK_DIR=$PLAT_THIRD_PARTY_DIR/lapack/
export LAPACK_BUILD_DIR=$BUILD_DIR/lapack/


# =============================================================================
# 1) ENVIRONMENT
# =============================================================================

echo $SCRIPT_NAME ": 1c Platform set up:  "
echo $SCRIPT_NAME ": 1c BUILD dir (BUILD_DIR) is                           = " $BUILD_DIR
echo $SCRIPT_NAME ": 1c INSTALLATION platform DIR (INSTALL_DIR) is         = " $PLAT_CODES_DIR/femus
echo $SCRIPT_NAME ": 1c INSTALL_PLAT_LOG_DIR  (log dir)                    = " $INSTALL_PLAT_LOG_DIR
echo $SCRIPT_NAME ": 1c INSTALL_PLAT_PKG_DIR  (application dir)            = " $INSTALL_PLAT_PKG_DIR
echo $SCRIPT_NAME ": Script set up for "  $SCRIPT_NAME ": 1 -> 1a. base dir -> 1b. make dir -> 1c. setup " 

INSTALL_PLAT_LOG_DIR=$BUILD_DIR/$LOG_DIR
INSTALL_DIR=$PLAT_THIRD_PARTY_DIR
INSTALL_BUILD_PKG_DIR=$BUILD_DIR/$PKG_NAME
INSTALL_PLAT_PKG_DIR=$PLAT_THIRD_PARTY_DIR/$PKG_NAME


cd $BUILD_DIR

# GET PACKAGE SOURCE FILES ===================================================
  if [ ! -d $LAPACK_DIR ]; then
    mkdir $LAPACK_DIR
    git clone https://github.com/Reference-LAPACK/lapack-release.git lapack
  else
    echo
    echo "Directory $LAPACK_DIR already exists"
    echo
  fi
  
  cd $LAPACK_DIR
  
   export OPTIONS="-DCMAKE_INSTALL_PREFIX=$LAPACK_DIR
                   -DBLAS++=ON
                   -DCBLAS=ON
                   -DBUILD_COMPLEX=ON
                   -DBUILD_DEPRECATED=ON
                   -DBUILD_SHARED_LIBS=ON
                   -DCMAKE_BUILD_TYPE=Release"
    
    echo  ccmake $OPTIONS $LAPACK_BUILD_DIR
    ccmake $OPTIONS $LAPACK_BUILD_DIR
    
    # COMPILE ==================================================================================================
    echo ${SCRIPT_NAME} ": 2c Configuration ended, now compiling"
    make -j2 >&  $INSTALL_PLAT_LOG_DIR/${SCRIPT_NAME}_compile.log
    if [ "$?" != "0" ];then
      echo -e " 2b${red}ERROR! Unable to compile, see the log${NC}"
      COMPLETED=1
      return
    fi
      
    # MAKE INSTALL =============================================================================================
    echo ${SCRIPT_NAME} ": 2d Compilation ended now installing"
    make install >& $INSTALL_PLAT_LOG_DIR/${SCRIPT_NAME}_install.log
    if [ "$?" != "0" ];then
      echo -e " 2b${red}ERROR! Unable to install, see the log${NC}"
      COMPLETED=1
      return
    fi
      
    echo ${SCRIPT_NAME} ": successfully installed! in " $INSTALL_PLAT_PKG_DIR


cd $BUILD_DIR
