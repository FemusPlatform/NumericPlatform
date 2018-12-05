# #############################################################################
# Install Petsc opt with OpenMPI
# #############################################################################

export VERSION=$1

if [ $VERSION == ""  ]; then
  echo "ERROR: no version given for PETSC installation "
  echo "Re-run petsc_opt.sh installer with additional version parameter"
  break
fi


export PKG_NAME=petsc-$VERSION
PKG_DIR=$PKG_NAME;
TAR_DIR=packages_targz;
LOG_DIR=package_logs

echo 
echo " --------- Start petsc_opt.sh script -------- "
echo
export SCRIPT_NAME=petsc
echo $SCRIPT_NAME ": script set up for "  $SCRIPT_NAME

cd ..
if [ -f "plat_conf.sh" ]; then
  source plat_conf.sh
  
  INSTALL_BUILD_TAR_DIR=$BUILD_DIR/$TAR_DIR
  INSTALL_PLAT_LOG_DIR=$BUILD_DIR/$LOG_DIR
  INSTALL_DIR=$PLAT_THIRD_PARTY_DIR
  export PKG_NAME_DIR=$BUILD_DIR/$PKG_NAME
  echo "PKG_NAME_DIR=" $BUILD_DIR/$PKG_NAME
  
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
  echo $SCRIPT_NAME ": 1d MPI dependency: OPENMPI_DIR                   = " $INSTALL_DIR/"openmpi/"             
  echo $SCRIPT_NAME ": 1d MPI dependency: PATH                          = " $INSTALL_DIR/"openmpi/bin/"          
  echo $SCRIPT_NAME ": 1d MPI dependency: LD_LIBRARY_PATH               = " $INSTALL_DIR/"openmpi/lib/"                                                                                                                        
  echo "-----------------------------------------------------------------------------------------"              
   
  # =============================================================================
  # 1) ==================  setup ================================================
  # =============================================================================
  cd $BUILD_DIR
  
  export PATH=$INSTALL_DIR/openmpi/bin/:$PATH
  export LD_LIBRARY_PATH=$INSTALL_DIR/openmpi/lib64/:$LD_LIBRARY_PATH
  export LD_LIBRARY_PATH=$INSTALL_DIR/openmpi/lib/:$LD_LIBRARY_PATH
  
  echo $SCRIPT_NAME ": 1d MPI dependency: OPENMPI_DIR="  $INSTALL_DIR"/openmpi/" 
  echo $SCRIPT_NAME ": 1d MPI dependency: PATH="$INSTALL_DIR/"openmpi/bin/"
  echo $SCRIPT_NAME ": 1d MPI dependency: LD_LIBRARY_PATH="$INSTALL_DIR/"openmpi/lib/"
  echo
  
  # =============================================================================
  # ======= 2 Install Petsc script  =============================================
  # =============================================================================
  echo
  echo $SCRIPT_NAME ": inst dir package=" $BUILD_DIR/$PKG_NAME
  # if dir  does not exit in BUILD_DIR
  if [ ! -d "$BUILD_DIR/$PKG_NAME/" ]; then
   
    if [ $VERSION == 'latest' ]; then
      git clone -b maint https://bitbucket.org/petsc/petsc petsc-$VERSION   
    else
      if [ ! -f $INSTALL_BUILD_TAR_DIR/${PKG_NAME}.tar.gz ]; then
        wget --progress=dot http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/${PKG_NAME}.tar.gz \
        2>&1 | grep "%" |  sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e  "s,\%,,g" \
        | dialog --gauge "Download petsc $VERSION" 10 100
        if [ $fast == 'no' ]; then 
          dialog --title "Done downloading" --msgbox "${PKG_NAME}.tar.gz dowloaded from http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/${PKG_NAME}.tar.gz" 10 50
        fi
          mv  ${PKG_NAME}.tar.gz    $INSTALL_BUILD_TAR_DIR/${PKG_NAME}.tar.gz
      fi
      if [ ! -d "$PKG_NAME_DIR" ]; then
        echo " ............  extracting the file: " $BUILD_DIR/packages_targz/$PKG_NAME.tar.gz "  ..............."
        tar -xzvf "$BUILD_DIR/packages_targz/$PKG_NAME.tar.gz"
        echo "............. done extracting ............................................"
      fi
    fi
    
    # CHECK PRESENCE OF FBLASLAPACK PACKAGE
    if [ ! -f $INSTALL_BUILD_TAR_DIR/fblaslapack-3.4.2.tar.gz ]; then
       wget --progress=dot http://ftp.mcs.anl.gov/pub/petsc/externalpackages/fblaslapack-3.4.2.tar.gz \
       2>&1 | grep "%" |  sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e  "s,\%,,g" \
       | dialog --gauge "Download fblaslapack 3.4.2" 10 100
       mv  fblaslapack-3.4.2.tar.gz  $INSTALL_BUILD_TAR_DIR/fblaslapack-3.4.2.tar.gz
       clear
    fi
  fi  
  
  cd $PKG_NAME_DIR
  
  export METHOD=opt
  export PETSC_DIR=$PKG_NAME_DIR
  export PETSC_ARCH=linux-opt
  export INST_PREFIX=$PLAT_THIRD_PARTY_DIR/$PKG_NAME/$PETSC_ARCH
  echo   $SCRIPT_NAME ": 2a prefix="$INST_PREFIX
  export LOGDIR=$BUILD_DIR/package_logs/
  echo   $SCRIPT_NAME ": 2a logdir="$LOGDIR 
  
  if [ ! -d "$BUILD_DIR/$PKG_NAME/$PETSC_ARCH" ]; then
 
    echo $SCRIPT_NAME ": 2 Compiling "$PKG_NAME" in debug mode"
    echo $SCRIPT_NAME ": 2 script-> 2a prefix -> 2b configure-> 2c make-> 2d test -> 2e install"
    
    # 2b configure-----------------------------------------------------------------
    echo $SCRIPT_NAME ": 2b starting configuration"
     
    export CONFIGURE_OPTIONS="--prefix=$INST_PREFIX 
                               --with-mpi-dir=$INSTALL_DIR/openmpi 
                               --with-shared-libraries=1 
                               --with-debugging=0
                               --download-fblaslapack=$INSTALL_BUILD_TAR_DIR/fblaslapack-3.4.2.tar.gz"

    ./configure $CONFIGURE_OPTIONS  >& $LOGDIR/petsc-opt_config.log
    if [ "$?" != "0" ]; then
      echo -e " 2b ${red}ERROR! Unable to configure${NC}"
      echo -e " 2b ${red}See the log for details${NC}"
      exit 1
    fi
    
    # 2c compiling ----------------------------------------------------------------
    echo $SCRIPT_NAME ": 2c Configuration ended, now compiling"
    make  >& $LOGDIR/petsc-opt_compiling.log
    if [ "$?" != "0" ]; then
      echo -e " 2c ${red}ERROR! Unable to compile${NC}"
      echo -e " 2c ${red}See the log for details${NC}"
      exit 1
    fi
    # 2d test---------------------------------------------------------
    echo $SCRIPT_NAME ": 2d testing"
    make test >& $LOGDIR/petsc-opt_testing.log
    if [ "$?" != "0" ]; then
      echo -e " 2d ${red}ERROR! Unable to run test examples${NC}"
      exit 1
    fi
    # 2e install---------------------------------------------------------
    echo $SCRIPT_NAME ": 2e installing"
    make install  >& $LOGDIR/petsc-opt_install.log
    if [ "$?" != "0" ]; then
      echo -e " 2e ${red}ERROR! Unable to install${NC}"
      exit 1
    fi
    echo $SCRIPT_NAME ": 2 "$PKG_NAME" in debug mode successfully installed!"
    #  end with no problems +++++++++++++++++++++++++++++++++++++++++++++++++
  
  else
    # installation with some problems +++++++++++++++++++++++++++++++++++++++++++++
    echo
    echo $SCRIPT_NAME ": 2 No installation "
    echo $SCRIPT_NAME ": 2 PETSC library has already been compiled in opt method "
    # endif dir does or does not exit in BUILD_DIR
  fi
  # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  #=============================================================================
  # 3 Post install ==============================================================
  # =============================================================================
  
  cd $BUILD_DIR
  if [ "$?" != "0" ]; then
    echo -e " 3 ${red}ERROR! Package not available${NC}"
    exit 1
  fi
  echo
  
  echo $SCRIPT_NAME " 3 script -> 3a liks -> 3b usage commands"
  
  # 3a link ---------------------------------------------------------------------
  rm -r $INSTALL_DIR/petsc
  echo $SCRIPT_NAME " 3a PETSC post-install: petsc -> petsc.version " 
  ln -s $INSTALL_DIR/$PKG_NAME/linux-opt  $INSTALL_DIR/petsc
  
  # 3b usage commands -----------------------------------------------------------
  echo  $SCRIPT_NAME " 3b PETSC post install: PETSC usage "
  echo "In order to run PETSC please set the following environment: "
  echo "export PETSC_DIR="$INSTALL_DIR/petsc
  echo "export PETSC_ARCH=linux-opt"
   
else

  echo  " Wrong directory or enviromnent !!!!! look for plat_conf.sh generated by plaftorm.sh !!!!!!"

fi
