# #############################################################################
# INSTALL FEMUS CODE
# -----------------------------------------------------------------------------
# This file script should be placed inside .../platform/plat_installation ($BUILD_DIR) and 
# the tar.gz package in the packages_targz dir ($BUILD_DIR/packages_targz)
# -----------------------------------------------------------------------------
# #############################################################################

export PKG_NAME=femus
SCRIPT_NAME=femus
BUILD_DIR=$PWD

cd ../                  # back to Numerical Platform main directory - Level 0
source plat_conf.sh     # set up environment

# =============================================================================
# 1) ENVIRONMENT
# =============================================================================

echo $SCRIPT_NAME ": 1c Platform set up:  "
echo $SCRIPT_NAME ": 1c BUILD dir (BUILD_DIR) is                           = " $BUILD_DIR
echo $SCRIPT_NAME ": 1c INSTALLATION platform DIR (INSTALL_DIR) is         = " $PLAT_CODES_DIR/femus_repo
echo $SCRIPT_NAME ": 1c INSTALL_PLAT_LOG_DIR  (log dir)                    = " $INSTALL_PLAT_LOG_DIR
echo $SCRIPT_NAME ": 1c INSTALL_PLAT_PKG_DIR  (application dir)            = " $INSTALL_PLAT_PKG_DIR
echo $SCRIPT_NAME ": Script set up for "  $SCRIPT_NAME ": 1 -> 1a. base dir -> 1b. make dir -> 1c. setup " 

cd $PLAT_CODES_DIR

# GET PACKAGE SOURCE FILES ===================================================
  if [ ! -d $PLAT_CODES_DIR/femus_repo ]; then
    git clone https://github.com/FemusPlatform/femus.git
  else
    echo
    echo "Directory $PLAT_CODES_DIR/femus_repo already exists"
    echo "To perform a fresh installation of FEMuS please remove the older directory"
    echo
  fi

cd $BUILD_DIR
