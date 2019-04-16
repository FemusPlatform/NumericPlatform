# #############################################################################
# INSTALL GETFEM CODE
# -----------------------------------------------------------------------------
# This file script should be placed inside .../platform/plat_installation ($BUILD_DIR) and 
# the tar.gz package in the packages_targz dir ($BUILD_DIR/packages_targz)
# -----------------------------------------------------------------------------
# #############################################################################

export PKG_NAME=getfem-5.3
SCRIPT_NAME=getfem
BUILD_DIR=$PWD
LOG_DIR=package_logs
TAR_DIR=packages_targz;

cd ../                  # back to Numerical Platform main directory - Level 0
source plat_conf.sh     # set up environment

export INSTALL_DIR=$PLAT_CODES_DIR/$PKG_NAME
INSTALL_BUILD_TAR_DIR=$BUILD_DIR/$TAR_DIR


# =============================================================================
# 1) ENVIRONMENT
# =============================================================================

cd $BUILD_DIR

# GET PACKAGE SOURCE FILES ===================================================

# CHECK PRESENCE OF SOURCE TAR FILE
if [ ! -f $INSTALL_BUILD_TAR_DIR/${PKG_NAME}.tar.gz ]; then
  wget --progress=dot download-mirror.savannah.gnu.org/releases/getfem/stable/getfem-5.3.tar.gz \
  2>&1 | grep "%" |  sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e  "s,\%,,g" \
  | dialog --gauge "Download getfem 5.3" 10 100
  clear
  if [ $fast == 'no' ]; then 
    dialog --title "Done downloading" --msgbox "${PKG_NAME}.tar.gz dowloaded from download-mirror.savannah.gnu.org/releases/getfem/stable/getfem-5.3.tar.gz " 10 50
    clear
  fi
    mv  ${PKG_NAME}.tar.gz    $INSTALL_BUILD_TAR_DIR/${PKG_NAME}.tar.gz
fi

# CHECK IF TAR FILE HAS ALREADY BEEN EXTRACTED
if [ ! -d "$PKG_NAME" ]; then
  cd $BUILD_DIR
  echo " ............  extracting the file: " $BUILD_DIR/packages_targz/$PKG_NAME.tar.gz "  ..............."
  tar -xzvf "$INSTALL_BUILD_TAR_DIR/$PKG_NAME.tar.gz" 
  echo "............. done extracting ............................................"
fi

cd ${PKG_NAME}
echo "-----------------------------------------------------------"
echo "Configuring GETFEM installation "   

CONFIG_LOG=$BUILD_DIR/$LOG_DIR/${SCRIPT_NAME}_config.log 
touch $CONFIG_LOG
./configure  --enable-qhull \
               CPPFLAGS="-I$PLAT_THIRD_PARTY_DIR/qhull/include/ -I$PLAT_THIRD_PARTY_DIR/lapack/include/" \
               LDFLAGS="-L$PLAT_THIRD_PARTY_DIR/qhull/lib/ -L$PLAT_THIRD_PARTY_DIR/lapack/lib64/"\
               LIBS=-llapack \
               BLAS_LIBS="-L$PLAT_THIRD_PARTY_DIR/lapack/lib64/ -lblas -llapack"\
               --prefix=$INSTALL_DIR  --with-pic  --enable-shared >& $CONFIG_LOG
               
if [ "$?" != "0" ]; then 
  echo "-----------------------------------------------------------"
  echo -e " Configure error: see $CONFIG_LOG file for details ";
else
  echo "-----------------------------------------------------------"
  echo "Configure step: ok, now compile "
  MAKE_LOG=$BUILD_DIR/$LOG_DIR/${SCRIPT_NAME}_compile.log 
  touch $MAKE_LOG
  
  make -j2 >& $MAKE_LOG
  
  if [ "$?" != "0" ]; then 
    echo "-----------------------------------------------------------"
    echo -e " Compile error: see $MAKE_LOG file for details ";
  else
    echo "-----------------------------------------------------------"
    echo "Compilation step: ok, now installing "
    INSTALL_LOG=$BUILD_DIR/$LOG_DIR/${SCRIPT_NAME}_install.log 
    touch $INSTALL_LOG
    
    make install >& $INSTALL_LOG
    
    ln -s $PLAT_CODES_DIR/$PKG_NAME $PLAT_CODES_DIR/$SCRIPT_NAME
    
    echo ${SCRIPT_NAME} ": successfully installed! in " $INSTALL_DIR
  fi
fi             
    
    
cd $BUILD_DIR
