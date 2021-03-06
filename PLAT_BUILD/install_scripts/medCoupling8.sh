# ##################################################################################################
# INSTALL MED COUPLING PACKAGE
# --------------------------------------------------------------------------------------------------
# This file script should be placed inside .../platform/plat_installation ($BUILD_DIR) and 
# the tar.gz package in the packages_targz dir ($BUILD_DIR/packages_targz)
# --------------------------------------------------------------------------------------------------
# ##################################################################################################
PKG_NAME=MedCoupling-$1
PKG_DIR=$PKG_NAME;
TAR_DIR=packages_targz;
LOG_DIR=package_logs
SCRIPT_NAME=medCoupling

red=`tput setaf 1`; bold=`tput bold `; green=`tput setaf 2`; reset=`tput sgr0`

cd ..
ls
if [  -f  "plat_conf.sh"  ]; then
  source plat_conf.sh
  
  INSTALL_PLAT_LOG_DIR=$BUILD_DIR/$LOG_DIR
  INSTALL_DIR=$PLAT_THIRD_PARTY_DIR
  INSTALL_BUILD_PKG_DIR=$BUILD_DIR/$PKG_NAME
  INSTALL_PLAT_PKG_DIR=$PLAT_THIRD_PARTY_DIR/$PKG_NAME
  
  echo " Getting the evironment Platform set up 1 Level directory from   plat_conf.sh script"                   
  echo "-----------------------------------------------------------------------------------------"              
  echo $SCRIPT_NAME ": 1c PLAT_DIR (platform or software or ...) is     = " $PLAT_DIR                           
  echo                                                                                                          
  echo $SCRIPT_NAME ": 1c BUILD dir (BUILD_DIR) is                      = " $BUILD_DIR                                     
  echo $SCRIPT_NAME ": 1c INSTALL_PLAT_LOG_DIR  (log dir)               = " $INSTALL_PLAT_LOG_DIR               
  echo                                                                                                          
  echo $SCRIPT_NAME ": 1c PLAT_THIRD_PARTY_DIR  (third party code dir)  = " $PLAT_THIRD_PARTY_DIR               
  echo $SCRIPT_NAME ": 1c PLAT_USERS_DIR  (users dir)                   = " $PLAT_USERS_DIR                     
  echo $SCRIPT_NAME ": 1c PLAT_CODES_DIR  (codes dir)                   = " $PLAT_CODES_DIR                     
  echo $SCRIPT_NAME ": 1c PLAT_VISU  (visualization dir)                = " $PLAT_VISU_DIR                      
  echo $SCRIPT_NAME ": 1d MPI dependency: OPENMPI_DIR                   = " $PLAT_THIRD_PARTY_DIR/"openmpi/"             
  echo $SCRIPT_NAME ": 1d MPI dependency: PATH                          = " $PLAT_THIRD_PARTY_DIR/"openmpi/bin/"          
  echo $SCRIPT_NAME ": 1d MPI dependency: LD_LIBRARY_PATH               = " $PLAT_THIRD_PARTY_DIR/"openmpi/lib/"   
  echo "-----------------------------------------------------------------------------------------"   
  echo " Configuration for medCoupling in" $CONFIGURATION_ROOT_DIR
  export CONFIGURATION_ROOT_DIR=$INSTALL_BUILD_PKG_DIR/$PKG_NAME/configuration-$1
  echo " LIB med  in" $INSTALL_DIR/med
  export MEDFILE_ROOT_DIR=$INSTALL_DIR/med

# ============================================================================= 
# 2) INSTALL
# =============================================================================

  cd $BUILD_DIR
  mkdir $PKG_NAME; cd $PKG_NAME ; 
  if [ ! -d $INSTALL_PLAT_PKG_DIR ]; then echo ${SCRIPT_NAME} ": 2 -> 2b configure-> 2c make-> 2d install"

    # GET PACKAGE SOURCE FILES =================================================================================
    git clone https://github.com/FemusPlatform/MedCoupling-$1.git
    echo
    cd $INSTALL_BUILD_PKG_DIR
    
    # CONFIGURE ================================================================================================
    echo ${SCRIPT_NAME} ": 2b starting configure command from"  $PWD "with ccmake " 
    CCMAKEDIR=$PKG_NAME/$PKG_NAME; echo ${CCMAKEDIR}
    
    # Find Boost from Salome prerequisites  
    export BoostDir=$(find $PLAT_THIRD_PARTY_DIR/salome/prerequisites/ -maxdepth 1 -type d -name 'Boost*' -print -quit)
    
    export OPTIONS="-DCMAKE_INSTALL_PREFIX=$INSTALL_PLAT_PKG_DIR   
                    -DBOOST_ROOT_DIR=$BoostDir
                    -DMEDCOUPLING_PARTITIONER_METIS=OFF 
                    -DMEDCOUPLING_PARTITIONER_SCOTCH=OFF 
                    -DMEDCOUPLING_ENABLE_PYTHON=OFF  
                    -DMEDCOUPLING_BUILD_DOC=OFF
                    -DCMAKE_CXX_COMPILER=$PLAT_THIRD_PARTY_DIR/openmpi/bin/mpicxx  
                    -DCMAKE_C_COMPILER=$PLAT_THIRD_PARTY_DIR/openmpi/bin/mpicc   
                    -DCMAKE_Fortran_COMPILER=$PLAT_THIRD_PARTY_DIR/openmpi/bin/mpif90 "
    
    ccmake $OPTIONS ./$CCMAKEDIR
    
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

  else  
    echo
    echo ${SCRIPT_NAME} ": 2 No installation, directory already exists: only linking " 
  fi
 

# =============================================================================
# 3) LINK
# =============================================================================

  cd $BUILD_DIR
  echo $SCRIPT_NAME " 3 -> 3a links"
   
  # LINK INTO PLAT_THIRD_PARTY DIRECTORY
  if [ -d $PLAT_THIRD_PARTY_DIR/MED_coupling ];  then   
    rm -r  $PLAT_THIRD_PARTY_DIR/MED_coupling 
    echo "ln deleted" 
  fi 
  echo  "ln -s $INSTALL_PLAT_PKG_DIR  $PLAT_THIRD_PARTY_DIR/MED_coupling       " 
  ln -s $INSTALL_PLAT_PKG_DIR  $PLAT_THIRD_PARTY_DIR/MED_coupling ;  echo $SCRIPT_NAME " 3a link -> salome/medCoupling"
   
  # LINK LIB DIRECTORIES
  if [ -d $INSTALL_PLAT_PKG_DIR/lib64 ]; then 
    rm -r $INSTALL_PLAT_PKG_DIR/lib64; 
    echo "ln deleted";
  fi
  echo ln from $INSTALL_PLAT_PKG_DIR/"lib" to $INSTALL_PLAT_PKG_DIR/"lib64"
  ln -s  $INSTALL_PLAT_PKG_DIR/lib $INSTALL_PLAT_PKG_DIR/lib64;
  
  cd $BUILD_DIR

else
  echo  " Wrong directory for this script !!!!! Go to plat_repo (BUILD_DIR) !!!!!!"
fi
