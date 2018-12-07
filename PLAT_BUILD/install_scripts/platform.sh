# ##################################################################################################
# Install platform
# --------------------------------------------------------------------------------------------------
# This file script should be placed inside .../platform/plat_installation ($BUILD_DIR or plat_repo) and 
# the tar.gz package in the packages_targz dir ($BUILD_DIR/packages_targz)
# --------------------------------------------------------------------------------------------------
# run from plat_repo as ./install_script/platform.sh
# ##################################################################################################

SCRIPT_NAME=platform_scripts
dir_script=install_scripts
 if [  -d $dir_script ] ; then
 

# =============================================================================
# 1) ================== environment setup =====================================
# =============================================================================
# ===============================================================================================
#   FIRST LEVEL DIRECTORIES
# ================================================================================================
# $PLAT_DIR(platform)   $BUILD_DIR(PLAT_REPO)  $INSTALL_BUILD_TAR_DIR(packages_targz)
#                                              $INSTALL_PLAT_LOG_DIR(packages_log)                                  
#                       $PLAT_THIRD_PARTY_DIR(PLAT_THIRD_PARTY)
#                       $PLAT_USERS_DIR(PLAT_USERS)
#                       $PLAT_CODES_DIR(PLAT_CODES)
#                       $PLAT_VISU_DIR(PLAT_VISU)
# =================================================================================================
echo
echo platform_script ": Script platform set up " 
echo

# 1a building and plat dir setup    --------->  BUILD_DIR
BUILD_DIR=$PWD
#  down to platform dir ------------------>  INSTALL_DIR
cd ../;  PLAT_DIR=$PWD

sed -e "4s|.*|export PLAT_DIR=$PLAT_DIR|" $PLAT_DIR/PLAT_BUILD/install_scripts/plat_conf_template.sh>$PLAT_DIR/plat_conf.sh

# 1b make directory -------------------------------------------------------------
ok=1
echo "platform_script": 1b set up: Check main installation directories: 
# if [ ! -d $PLAT_DIR ]; 
#   then  echo -e  " Directory .../platform/plat_repo  does not already exists !!!!!"; 
#   ok=1 ;  
#   else  echo -e  " Directory .../platform/plat_repo  does already exists. Overwriting "; 
#   ok=0; 
# fi

# ZIPPED PACKAGE DIRECTORY
INSTALL_BUILD_TAR_DIR=$BUILD_DIR/packages_targz/
if [ ! -d $INSTALL_BUILD_TAR_DIR ]; 
  then  echo -e  "Directory $BUILD_DIR/packages_targz dir dos not already exists"; 
  mkdir $INSTALL_BUILD_TAR_DIR
  ok=1 ;  
else  echo -e  "Directory $BUILD_DIR/packages_targz does already exists. Overwriting "; 
  ok=0; 
fi


# INSTALLATION LOG DIRECTORY
INSTALL_PLAT_LOG_DIR=$BUILD_DIR/package_logs
if [ ! -d $INSTALL_PLAT_LOG_DIR ]; 
  then  mkdir  $INSTALL_PLAT_LOG_DIR;  
else  echo -e " Directory .../platform/package_logs does already exists. Overwriting "; 

fi

echo Check main installation directories  1 level = $ok

echo "platform_script":  make  level 1 directories: 
PLAT_THIRD_PARTY_DIR=$PLAT_DIR/PLAT_THIRD_PARTY
if [ ! -d $PLAT_THIRD_PARTY_DIR ]; then  mkdir $PLAT_THIRD_PARTY_DIR;  
else  echo -e " Directory .../platform/plat_third_party does already exist! "; fi
PLAT_USERS_DIR=$PLAT_DIR/PLAT_USERS
if [ ! -d $PLAT_USERS_DIR ]; then  mkdir $PLAT_USERS_DIR;  
else  echo -e " Directory .../platform/plat_users does already exist! "; fi
PLAT_CODES_DIR=$PLAT_DIR/PLAT_CODES
if [ ! -d $PLAT_CODES_DIR ]; then  mkdir $PLAT_CODES_DIR;  
else  echo -e " Directory .../platform/plat_codes does already exist! "; fi
PLAT_VISU_DIR=$PLAT_DIR/PLAT_VISU
if [ ! -d $PLAT_VISU_DIR ]; then  mkdir $PLAT_VISU_DIR;  
else  echo -e " Directory .../platform/plat_visu does already exist! "; fi


# 1c --------------- platform setup -------------------------------------------
echo
echo
echo
echo $SCRIPT_NAME ": 1c Platform set up 1 Level directory  ------> plat_conf.sh: summary "
echo "-----------------------------------------------------------------------------------------"
echo $SCRIPT_NAME ": 1c Platform DIR (platform or software or ...) is = " $PLAT_DIR
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
echo
echo "  plat_conf.sh " generated
echo

cd $BUILD_DIR

else
echo   "Wrong directory for this script !!!!! Go to plat_repo (BUILD_DIR) !!!!!!"
fi
 
#
# ADDING NumericPlatform ALIAS TO ~/.bashrc
#
echo "NumericPlatform='export MYHOME=$PLAT_DIR && cd $MYHOME && source plat_conf.sh '" >> ~/.bashrc
 
