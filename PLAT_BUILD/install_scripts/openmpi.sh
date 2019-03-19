# ##################################################################################################
# Install OpenMPI
# --------------------------------------------------------------------------------------------------
# This file script should be placed inside .../platform/plat_installation ($BUILD_DIR) and 
# the tar.gz package in the packages_targz dir ($BUILD_DIR/packages_targz)
# ##################################################################################################
# 
export CompleteVersion=$1

if [ $CompleteVersion == ""  ]; then
  echo "ERROR: no version given for OPENMPI installation "
  echo "Re-run openmpi.sh installer with additional version parameter"
  break
fi

export OMPMajor=${CompleteVersion:0:1}
export OMPMinor=${CompleteVersion:2:1}
export OMPPatch=${CompleteVersion:4:1}

PKG_NAME=openmpi-$1
PKG_DIR=$PKG_NAME;
TAR_DIR=packages_targz;
LOG_DIR=package_logs
SCRIPT_NAME=openmpi

# utility functions -----------------------------------------------------------
red=`tput setaf 1`; bold=`tput bold `; green=`tput setaf 2`; reset=`tput sgr0`

cd ..
if [ -f "plat_conf.sh" ]; then
  source plat_conf.sh
  
  INSTALL_BUILD_TAR_DIR=$BUILD_DIR/$TAR_DIR
  INSTALL_PLAT_LOG_DIR=$BUILD_DIR/$LOG_DIR
   
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
  echo "-----------------------------------------------------------------------------------------" 
   
  
  INSTALL_PLAT_PKG_DIR=$BUILD_DIR/$PKG_NAME
  echo INSTALL_PLAT_PKG_DIR= $INSTALL_PLAT_PKG_DIR
  
  # ==========================================================================================================
  # 2) Install OpenMPI script  ================================================================================
  # ===========================================================================================================
  cd $BUILD_DIR
   
  #if dir  does not exit in MY_PREFIX_DIR ***************************************
  if [ ! -d $PLAT_THIRD_PARTY_DIR/${PKG_NAME} ]; then echo ${SCRIPT_NAME} ": 2 -> 2b configure-> 2c make-> 2d install"
  
     # CHECK EXISTANCE OF SOURCE ZIPPED PACKAGE
     if [ ! -f $INSTALL_BUILD_TAR_DIR/${PKG_NAME}.tar.gz ] ; then
        wget --progress=dot https://download.open-mpi.org/release/open-mpi/v$OMPMajor.$OMPMinor/openmpi-$CompleteVersion.tar.gz \
        2>&1 | grep "%" | sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e "s,\%,,g" \
        | dialog --gauge "Download openmpi" 10 100
        clear
        if [ $fast == 'no' ]; then 
          dialog --title "Done downloading" --msgbox "openmpi-$CompleteVersion.tar.gz dowloaded from https://download.open-mpi.org/release/open-mpi/v$OMPMajor.$OMPMinor/openmpi-$CompleteVersion.tar.gz" 10 50
          clear
        fi
        mv ${PKG_NAME}.tar.gz   $INSTALL_BUILD_TAR_DIR/${PKG_NAME}.tar.gz
     fi
     
     
     #  uncompress the tar.gz file if needed --------------------------------------------------------------------
     if [ ! -d $PKG_DIR ]; then  echo " extracted file: "$INSTALL_BUILD_TAR_DIR/$PKG_NAME".tar.gz "
        tar -xzvf "$INSTALL_BUILD_TAR_DIR/$PKG_NAME.tar.gz"
     fi
     
     cd $INSTALL_PLAT_PKG_DIR
     # 2b configure ---------------------------------------------------------------------------------------------
     echo ${SCRIPT_NAME} ": 2b starting configure command" 
     ./configure --prefix=$PLAT_THIRD_PARTY_DIR/${PKG_NAME} \
                 --libdir=$PLAT_THIRD_PARTY_DIR/${PKG_NAME}/lib \
                 >& $INSTALL_PLAT_LOG_DIR/${SCRIPT_NAME}_config.log
     if [ "$?" != "0" ]; then 
        COMPLETED=1
        echo -e " 2b${red}ERROR! Unable to configure, see the log${NC}" 
        return 
     fi
  
     # 2c compiling ---------------------------------------------------------------------------------------------
     echo ${SCRIPT_NAME} ": 2c Configuration ended, now compiling"
     make -j2 >&  $INSTALL_PLAT_LOG_DIR/${SCRIPT_NAME}_compile.log
     if [ "$?" != "0" ]; then 
        COMPLETED=1
        echo -e " 2b${red}ERROR! Unable to compile, see the log${NC}"
        return 
     fi
  
     # 2d make install ------------------------------------------------------------------------------------------
     echo ${SCRIPT_NAME} ": 2d Compilation ended now installing"
     make install >& $INSTALL_PLAT_LOG_DIR/${SCRIPT_NAME}_install.log
     if [ "$?" != "0" ]; then 
        COMPLETED=1
        echo -e " 2b${red}ERROR! Unable to install, see the log${NC}"
        return 
     fi
  
     echo ${SCRIPT_NAME} ": successfully installed! in " $INSTALL_PLAT_PKG_DIR
     # **********************************************************************************************************
  
     
  else  echo; echo ${SCRIPT_NAME} ": 2 No installation, directory already exists: only linking " 
  fi
   
   
   
   
#   # ============================================================================================================
#   # 3 post install =============================================================================================
#   # ============================================================================================================
  cd $BUILD_DIR
  if [ "$?" != "0" ];then echo -e "3a ${red}ERROR! installation dir not here ${NC}";exit 1;fi
#   
  echo; echo ${SCRIPT_NAME} " 3 -> 3a links -> 3b ${SCRIPT_NAME} usage commands"
  # 3a link ----------------------------------------------------------------------------------------------------
  
  
  if [ -d $PLAT_THIRD_PARTY_DIR/${SCRIPT_NAME} ] 
    then 
    rm -r $PLAT_THIRD_PARTY_DIR/${SCRIPT_NAME}
    echo "ln deleted"
  fi
  
  ln -s $PLAT_THIRD_PARTY_DIR/${PKG_NAME}  $PLAT_THIRD_PARTY_DIR/${SCRIPT_NAME};
  echo ${SCRIPT_NAME} ": 3a ln -s" $PLAT_THIRD_PARTY_DIR/${PKG_NAME}   $PLAT_THIRD_PARTY_DIR/${SCRIPT_NAME}

  ln -s $PLAT_THIRD_PARTY_DIR/${SCRIPT_NAME}/lib  $PLAT_THIRD_PARTY_DIR/${SCRIPT_NAME}/lib64
  echo ${SCRIPT_NAME} ": 3a ln -s" $PLAT_THIRD_PARTY_DIR/${SCRIPT_NAME}/lib  $PLAT_THIRD_PARTY_DIR/${SCRIPT_NAME}/lib64; 
  
  # 3b Print comment how to use it -----------------------------------------------------------------------------
  echo " ${green}3b We add to plat_conf.sh the path the ${SCRIPT_NAME} executables and libraries  to use it: "
  echo " export PATH="$PLAT_THIRD_PARTY_DIR/${SCRIPT_NAME}"/bin/:$PATH}"
  echo " export LD_LIBRARY_PATH="$PLAT_THIRD_PARTY_DIR/${SCRIPT_NAME}"/lib64/:$LD_LIBRARY_PATH}"
  echo " export LD_LIBRARY_PATH="$PLAT_THIRD_PARTY_DIR/${SCRIPT_NAME}"/lib/:$LD_LIBRARY_PATH}${reset}"
  echo
  echo " plat_conf.sh  generated with MPI dependence"
  echo
  
else
  
  echo  " Wrong directory or enviromnent !!!!! look for plat_conf.sh generated by plaftorm.sh !!!!!!"

fi


