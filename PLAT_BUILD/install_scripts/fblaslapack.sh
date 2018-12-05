# #############################################################################
# Install fblaslapack
# #############################################################################
PKG_NAME=fblaslapack-3.4.2
# ##################################################################################################
# --------------------------------------------------------------------------------------------------
# This file script should be placed inside .../platform/plat_installation ($BUILD_DIR) and 
# the tar.gz package in the packages_targz dir ($BUILD_DIR/packages_targz)
# --------------------------------------------------------------------------------------------------
# ##################################################################################################
# ##################################################################################################
# ##################################################################################################

# ##################################################################################################
# ##################################################################################################
# ##################################################################################################
SCRIPT_NAME=fblaslapack

# utility functions -----------------------------------------------------------
 red=`tput setaf 1`; bold=`tput bold `; green=`tput setaf 2`; reset=`tput sgr0`

 # =============================================================================
 # 1) ================== environment setup =====================================
 # =============================================================================
 
 # =================================================================================================
 #              -> VIS_DIR      (plat_vis)    -> INSTALL_VIS_PKG_DIR (PKG_NAME)
 #  INSTALL_DIR -> BUILD_DIR    (plat_install)-> INSTALL_BUILD_TAR_DIR ($BUILD_DIR/packages_targz)
 #  (software)                                -> INSTALL_BUILD_PKG_DIR ($BUILD_DIR/PKG_NAME)
 #                                                    -> doc  (no)
 #                                                    -> patches (no)
 #                                                    -> scripts (no)
 #                 PLAT_DIR (plat_base_packs) -> INSTALL_PLAT_PKG_DIR (plat_base_packs+$PKG_NAME) 
 #                                            -> INSTALL_PLAT_LOG_DIR (plat_base_packs/package_logs)
 # =================================================================================================
 echo $SCRIPT_NAME ": Script set up for "  $SCRIPT_NAME ": 1 -> 1a. base dir -> 1b. make dir -> 1c. setup " 
 # 1a building (plat_install) dir    --------->  BUILD_DIR
 BUILD_DIR=$PWD
 #  down to platform dir ------------------>  INSTALL_DIR
 cd ../;  INSTALL_DIR=$PWD
 # 1b make directory -------------------------------------------------------------
 echo $SCRIPT_NAME ": 1b set up: make directories:" 
 PLAT_DIR=plat_base_packs
 if [ ! -d $PLAT_DIR ]; then   mkdir ./$PLAT_DIR;  
 else  echo -e  " plat_base_packs dir already exists. Overwriting "; fi
 if [ ! -d $PLAT_DIR/$LOG_DIR ]; then  mkdir ./$PLAT_DIR/$LOG_DIR;  
 else  echo -e " packagelogs dir already exists. Overwriting "; fi
 
 # 1c --------------- platform setup -------------------------------------------
 GUI_PREFIX_DIR=plat_vis_gui; INSTALL_GUI_DIR=$INSTALL_DIR/$GUI_PREFIX_DIR
 INSTALL_BUILD_TAR_DIR=$BUILD_DIR/packages_targz/
 INSTALL_BUILD_PKG_DIR=$BUILD_DIR/$PKG_NAME
 INSTALL_PLAT_PKG_DIR=$INSTALL_DIR/$PLAT_DIR/$PKG_NAME
 INSTALL_PLAT_DIR=$INSTALL_DIR/$PLAT_DIR/
 INSTALL_PLAT_LOG_DIR=$INSTALL_DIR/$PLAT_DIR/$LOG_DIR
 
 echo $SCRIPT_NAME ": 1c Platform set up:  "
 echo $SCRIPT_NAME ": 1c BUILD dir (BUILD_DIR) is                           = " $BUILD_DIR
 echo $SCRIPT_NAME ": 1c INSTALLATION platform DIR (INSTALL_DIR) is         = " $INSTALL_DIR
 echo $SCRIPT_NAME ": 1c INSTALL_PLAT_LOG_DIR  (log dir)                    = " $INSTALL_PLAT_LOG_DIR
 echo $SCRIPT_NAME ": 1c INSTALL_PLAT_PKG_DIR  (application dir)            = " $INSTALL_PLAT_PKG_DIR
 echo $SCRIPT_NAME ": 1c INSTALL_BUILD_TAR_DIR (package archive dir)        = " $INSTALL_BUILD_TAR_DIR
 echo $SCRIPT_NAME ": 1c INSTALL_BUILD_PKG_DIR (package dir)                = " $INSTALL_BUILD_PKG_DIR
 
# ==========================================================================================================
# 2) Install fblaslapack script  ==================================================
# ==========================================================================================================


 #if dir  does not exit in MY_PREFIX_DIR ***************************************
 if [ ! -d $INSTALL_BUILD_PKG_DIR ]; then echo $SCRIPT_NAME ": 2 -> 2a extracting->  2b install"
    cd $BUILD_DIR
    
    #  uncompress the tar.gz file if needed --------------------------------------------------------------------
    if [ ! -d $INSTALL_BUILD_PKG_DIR ]; then  echo " extracted file: "$INSTALL_BUILD_TAR_DIR/$PKG_NAME".tar.gz "
       tar -xzvf "$INSTALL_BUILD_TAR_DIR/$PKG_NAME.tar.gz"
    fi
    
   
    echo; echo $SCRIPT_NAME ": 2 $SCRIPT_NAME installed " 
    # **********************************************************************************************************
 else  echo; echo $SCRIPT_NAME ": 2 No installation, directory already exists" 
 fi


# ==========================================================================================================
# 3) Post install fblaslapack script  ==================================================
# ==========================================================================================================

cd $BUILD_DIR
