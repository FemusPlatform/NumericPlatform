# #############################################################################
# Utility
# #############################################################################
red=`tput setaf 1`; bold=`tput bold `; green=`tput setaf 2`; reset=`tput sgr0`

# ==============================================================================
function setting_env {
 # ----------------------------------------------------------------------------
 # Environment setting function
 # -----------------------------------------------------------------------------
 # ====================================================================================================================
 #    dir names                     
 # ====================================================================================================================
 #                         ->   VIS_DIR      (plat_vis)         -> INSTALL_VIS_PKG_DIR (PKG_NAME)
 #  INSTALL_DIR(software)  ->   BUILD_DIR    (plat_install)     -> INSTALL_BUILD_TAR_DIR ($BUILD_DIR/packages_targz)
 #                                                              -> INSTALL_BUILD_PKG_DIR ($BUILD_DIR/PKG_NAME)
 #                                                                      -> doc  (no)
 #                                                                      -> patches (no)
 #                                                                      -> scripts (no)
 #                              PLAT_DIR (plat_base_packs)      -> INSTALL_PLAT_PKG_DIR (plat_base_packs+$PKG_NAME) 
 #                                                              -> INSTALL_PLAT_LOG_DIR  (plat_base_packs/package_logs) 
 # =====================================================================================================================
 # second fist level 
 echo $1-setting_env ": Script set up for "  $1 
 echo
 echo $1-setting_env  ": 1 -> 1a.build dir-> 1b.log dir -> 1c.femus_install dir"

 # 1a --------------- platform setup -------------------------------------------
 BUILD_DIR_ENV=$PWD
 cd ../
 #  down to platform dir 
 INSTALL_DIR_ENV=$PWD
 # 1b log directory -------------------------------------------------------------
 echo $1-setting_env ": 1b set up: make directories" 
 mkdir ./$2
 mkdir ./$2/$LOG_DIR
 if [ "$?" != "0" ]; then
   echo -e $1-setting_env ": 1b packagelogs and plat_base_packs already exist. Overwriting "
 fi
}

# ==============================================================================
# =============================================================================
# This function extracts the file $2/$1.tar.gz into 
#  $1=name_package $2=dir=istallation_path/plat_install/packages_targz
function install_untar {
 #  uncompress the tar.gz file if needed
  if [ ! -d "$1" ] 
  then
     echo " ............  extracting the file: "$2/$1".tar.gz ..............."
     tar -xzvf "$2/$1.tar.gz"
     echo "............. done extracting ............................................"
  fi
 
   
}
# =============================================================================
 # =============================================================================
function install_configure { 

  # 2b configure ----------------------------------------------------------------
  echo $1-install_configure ": 2b starting configure command" 
   echo --prefix=$3   $4   $5   $6   $7 ">&"  $2/$1_config.log
   ./configure --prefix=$3 $4 $5 $6 $7 >& $2/$1_config.log
  if [ "$?" != "0" ]; then
    echo -e " 2b ${red}ERROR! Unable to configure${NC}"
      echo -e "  2b ${red}See the log for details${NC}"
    exit 1
  fi
}
# ==============================================================================
# ==================================================================================
function install_compiling { 

  # 2c compiling -------------------------------------------------------------------
  echo $1-install_compiling ": 2c Configuration ended, now compiling"
  make $3 >&  $2/$1_compile.log
  if [ "$?" != "0" ]; then
    echo -e " 2c ${red}ERROR! Unable to compile${NC}"
      echo -e " 2c ${red}See the log for details${NC}"
    exit 1
  fi
}
# ==================================================================================
# ==================================================================================
function install_testing { 
  # 2c/d testing -------------------------------------------------------------------
  echo $1-install_testing ": 2c Compilation ended, now testing"
  make test >& $2/$1_testing.log 
  if [ "$?" != "0" ]; then
    echo -e " 2c ${red}ERROR! Unable to test ${NC}"
      echo -e " 2c ${red}See the log for details${NC}"
    exit 1
  fi
}
# ==================================================================================

# =================================================================================
function install_install { 
  # 2d make install ----------------------------------------------------------------
  echo $1-install_install ": 2d Compilation ended now installing"
  make install >& $2/$1_install.log
  if [ "$?" != "0" ]; then
    echo -e " 2d ${red}ERROR! Unable to install${NC}"
      echo -e " 2d ${red}See the log for details${NC}"
    exit 1
  fi
}
# =================================================================================
# =================================================================================
function link_1 { 
 if [ ! -d "$2" ] 
  then
  ln -s $1  $2
 else
  rm -r $2
  ln -s $1  $2
 fi
}
# =================================================================================




