# ##################################################################################################
# SCRIPT FOR MED PACKAGE INSTALLATION
# --------------------------------------------------------------------------------------------------
# This file script should be placed inside platform_dir/plat_repo/install_scripts
# --------------------------------------------------------------------------------------------------

PKG_NAME=gmsh-4.2.2
PKG_DIR=$PKG_NAME;
LOG_DIR=package_logs
TAR_DIR=packages_targz
SCRIPT_NAME=gmsh

red=`tput setaf 1`; bold=`tput bold `; green=`tput setaf 2`; reset=`tput sgr0`

# =============================================================================
# 1) ENVIRONMENT SETUP
# =============================================================================

cd ..
ls
if [  -f  "plat_conf.sh"  ]; then
source plat_conf.sh

INSTALL_PLAT_LOG_DIR=$BUILD_DIR/$LOG_DIR
INSTALL_DIR=$PLAT_THIRD_PARTY_DIR
MY_PREFIX_DIR=$BUILD_DIR
INSTALL_BUILD_PKG_DIR=$BUILD_DIR/$PKG_NAME
INSTALL_PLAT_PKG_DIR=$PLAT_THIRD_PARTY_DIR/$PKG_NAME
PLAT_PKG_TARGZ=$BUILD_DIR/$TAR_DIR/$PKG_NAME-source.tgz

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
echo $SCRIPT_NAME ": 1d MPI dependency: OPENMPI_DIR                   = " $PLAT_THIRD_PARTY_DIR/"gmsh/"             
echo $SCRIPT_NAME ": 1d MPI dependency: PATH                          = " $PLAT_THIRD_PARTY_DIR/"gmsh/bin/"          
echo $SCRIPT_NAME ": 1d MPI dependency: LD_LIBRARY_PATH               = " $PLAT_THIRD_PARTY_DIR/"gmsh/lib/"   
echo $SCRIPT_NAME ": PLAT_PKG_TARGZ                                   = " $PLAT_PKG_TARGZ   
echo "-----------------------------------------------------------------------------------------"   
 
# ============================================================================= 
# 2) INSTALLING
# =============================================================================

#if dir  does not exit in MY_PREFIX_DIR ***************************************
   cd $BUILD_DIR
   mkdir $PKG_NAME; 
   cd $PKG_NAME
   
   # CHECK EXISTANCE OF SOURCE ZIPPED PACKAGE
     if [ ! -f $PLAT_PKG_TARGZ ] ; then
        wget --progress=dot http://gmsh.info/src/$PKG_NAME-source.tgz \
        2>&1 | grep "%" | sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e "s,\%,,g" \
        | dialog --gauge "Download gmsh" 10 100
        clear
        if [ $fast == 'no' ]; then 
          dialog --title "Done downloading" --msgbox "$PKG_NAME.tgz dowloaded from http://gmsh.info/src/$PKG_NAME-source.tgz" 10 50
          clear
        fi
        mv $PKG_NAME-source.tgz   $PLAT_PKG_TARGZ
     fi
   
   # GET PACKAGE SOURCE FILES =================================================================================
   if [ ! -d $PKG_DIR ]; then
     tar -zxvf $PLAT_PKG_TARGZ  $PLAT_BUILD
   fi
      
if [ ! -d $INSTALL_PLAT_PKG_DIR ]; then echo ${SCRIPT_NAME} ": 2 -> 2b configure-> 2c make-> 2d install"

   cd $INSTALL_BUILD_PKG_DIR
      
   # CONFIGURE ================================================================================================
   echo ${SCRIPT_NAME} ": 2b starting configure command from"  $PWD "with ccmake " 
   CCMAKEDIR=$PKG_NAME-source; echo ${CCMAKEDIR}
   
   export MED_DIR=$PLAT_THIRD_PARTY_DIR/med
   
   export OPTIONS="-DCMAKE_INSTALL_PREFIX=$INSTALL_PLAT_PKG_DIR/
                   -DCMAKE_CXX_COMPILER=$PLAT_THIRD_PARTY_DIR/openmpi/bin/mpicxx  
                   -DCMAKE_C_COMPILER=$PLAT_THIRD_PARTY_DIR/openmpi/bin/mpicc   
                   -DCMAKE_CXX_FLAGS=-I$MED_DIR/include/
                   -DMED_LIB=$MED_DIR/lib/libmed.so;$MED_DIR/lib/libmedC.so"
                   
   ccmake $OPTIONS  ./$CCMAKEDIR
   
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
  
else  echo; echo ${SCRIPT_NAME} ": 2 No installation, directory already exists: only linking " 
fi
 
# =============================================================================
# 3) LINKING
# =============================================================================

cd $BUILD_DIR
echo $SCRIPT_NAME " 3 -> 3a links"

# LINK FOLDER INSIDE PLAT_THIRD_PARTY_DIR
if [ -d $PLAT_THIRD_PARTY_DIR/$SCRIPT_NAME ];  then   rm -r  $PLAT_THIRD_PARTY_DIR/$SCRIPT_NAME ;echo "ln deleted" ;fi 
echo ln from $INSTALL_PLAT_PKG_DIR to  $PLAT_THIRD_PARTY_DIR/$SCRIPT_NAME
ln -s $INSTALL_PLAT_PKG_DIR  $PLAT_THIRD_PARTY_DIR/$SCRIPT_NAME;  

# LINK FOLDER INSIDE PLAT_THIRD_PARTY_DIR
if [ -d $PLAT_VISU_DIR/$SCRIPT_NAME ];  then   rm -r  $PLAT_VISU_DIR/$SCRIPT_NAME ;echo "ln deleted" ;fi 
echo ln from $INSTALL_PLAT_PKG_DIR to  $PLAT_VISU_DIR/$SCRIPT_NAME
ln -s $INSTALL_PLAT_PKG_DIR  $PLAT_VISU_DIR/$SCRIPT_NAME;  

cd $BUILD_DIR

else
 echo  " Wrong directory for this script !!!!! Go to plat_repo (BUILD_DIR) !!!!!!"
fi
