# ##################################################################################################
# Install Salome
# --------------------------------------------------------------------------------------------------
# This file script should be placed inside .../platform/plat_installation ($BUILD_DIR) and 
# the tar.gz package in the packages_targz dir ($BUILD_DIR/packages_targz)
# --------------------------------------------------------------------------------------------------
# ##################################################################################################
# SALOME name setup 
SALOME_HDF5_DIR=prerequisites/Hdf5-1103/
SALOME_med_dir=prerequisites/Medfichier-400

TAR_DIR=packages_targz;
LOG_DIR=package_logs

export CompleteVersion=$1
# 0 ##################################################################################################
if [ "$1" == ""  ]; then
  echo "ERROR: no version given for SALOME installation "
  echo "Re-run salome.sh installer with additional version parameter"
 else
  echo " Installing Salome version"  $1
 
  export SalMajor=${CompleteVersion:0:1}
  export SalMinor=${CompleteVersion:2:1}
  export SalPatch=${CompleteVersion:4:1}
  export INSTALL_VERSION="V"$SalMajor"_"$SalMinor"_"$SalPatch
  export DOWNLOAD_PKG=Salome-V$CompleteVersion-univ

  PKG_NAME=Salome-$INSTALL_VERSION-univ
  SHORT_PKG_NAME=Salome-$INSTALL_VERSION

  SALOME_MED_DIR=modules/FIELDS_$INSTALL_VERSION/
  SALOME_MED_COUPL_DIR=tools/Medcoupling-$INSTALL_VERSION

  # ##################################################################################################
  SCRIPT_NAME=salome
  # utility functions -----------------------------------------------------------
  source install_scripts/utility.sh
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
# ": 1 -> 1a.build dir-> 1b.log dir -> 1c.femus_install dir"

INSTALL_PLAT_LOG_DIR=$BUILD_DIR/$LOG_DIR
INSTALL_BUILD_TAR_DIR=$BUILD_DIR/$TAR_DIR
# INSTALL_PLAT_PKG_DIR=${BUILD_DIR}/${PKG_NAME}
INSTALL_PLAT_PKG_DIR=${BUILD_DIR}/${PKG_NAME}_public

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
echo
echo $SCRIPT_NAME "inst dir package                                   = " $INSTALL_PLAT_PKG_DIR
echo "-----------------------------------------------------------------------------------------"

# ============================================================================= 
# 2) Install Salome script  ==================================================
# =============================================================================
# A ===============================================================================
if [ $PLAT_DIR == "" ]; then
 echo; echo $SCRIPT_NAME " 2 No installation, directory already exists: only linking"

 else
 cd $BUILD_DIR

 # B ===============================================================================
 if [  -d $INSTALL_PLAT_PKG_DIR ] ; then  
    echo $SCRIPT_NAME " no salome package "
 else
 cd $BUILD_DIR
 ok=0  
 echo  " searching .. "  $INSTALL_BUILD_TAR_DIR/${DOWNLOAD_PKG}_public.run
   
 # check existance in packages_targz directory -----------------------------------------------------------------
#  if [ ! -f packages_targz/Salome-V$CompleteVersion-univ_public.run ] ; then ok=0; 
#         wget --progress=dot 'https://www.salome-platform.org/downloads/current-version/DownloadDistr?platform=UniBinNew2&version='$CompleteVersion'_64bit' \
#         2>&1 | grep "%" | sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e "s,\%,,g" \
#         | dialog --gauge "We are downloading SALOME" 10 100
#        clear
# #        if [ '$fast' == 'no' ]; then 
# #          dialog --title "Done downloading" --msgbox "Salome-V"$1".run dowloaded from https://www.salome-platform.org/downloads" 10 50
# #          clear
# #  echo moving ...to $INSTALL_BUILD_TAR_DIR/${DOWNLOAD_PKG}_public.run
#  mv DownloadDistr?platform=UniBinNew2\&version=$1_64bit packages_targz/Salome-V$CompleteVersion-univ_public.run
#  fi;
   # ---------------------------------------------------------------------------------------------------
#     $INSTALL_BUILD_TAR_DIR/Salome-V9_2_0-univ_public.run ->
#  if [ -f $INSTALL_BUILD_TAR_DIR/${DOWNLOAD_PKG}_public.run ] ; then ok=1; 
#        echo  " copy "  $INSTALL_BUILD_TAR_DIR/${DOWNLOAD_PKG}_public.run
#     cp  $INSTALL_BUILD_TAR_DIR/${DOWNLOAD_PKG}_public.run  ./ ; 
#  fi 
#   -----------------------------------------------------------------------
#   Salome-V9_2_0-univ_public.run.tar.gz
#   if [ -f $INSTALL_BUILD_TAR_DIR/${PKG_NAME}_public.run.tar.gz ] ; then ok=1; 
#       echo  " exctract " $INSTALL_BUILD_TAR_DIR/${PKG_NAME}_public.run.tar.gz
#       tar -xzvf $INSTALL_BUILD_TAR_DIR/${PKG_NAME}_public.run.tar.gz;   
#  fi
#   -------------------------------------------------------------------------------
#  if [ ${ok} == 1 ]; then     
#      echo $SCRIPT_NAME " 2 ->  2a install -> 2c links"
#      # 2a installing  --------------------------------------------------------------
#      echo $SCRIPT_NAME " 2a Now installing "
#      sh ${DOWNLOAD_PKG}_public.run -t $BUILD_DIR -a $PLAT_VISU_DIR/appli_salome -l ENGLISH
#  fi
 # B ===============================================================================
fi
  
# A ===============================================================================
fi
 


# =============================================================================
# 3) link =====================================================================
# =============================================================================

cd $BUILD_DIR
echo $SCRIPT_NAME " 3 -> 3a links"

# 3a main  link ---------------------------------------------------------------------
echo $SCRIPT_NAME " 3a link salome -> ../plat_base_packs/salome.version "


# 3a libraries  link ---------------------------------------------------------------------
if [ -L $PLAT_THIRD_PARTY_DIR/salome ];  then rm -r $PLAT_THIRD_PARTY_DIR/salome; echo "salome ln deleted" ; fi                  
ln -s ${INSTALL_PLAT_PKG_DIR}  ${PLAT_THIRD_PARTY_DIR}/salome  ; 
echo $SCRIPT_NAME " 3a link -> salome from"  $INSTALL_PLAT_PKG_DIR/ "to"  $PLAT_THIRD_PARTY_DIR/salome


if [ -L $PLAT_THIRD_PARTY_DIR/hdf5 ];  then rm -r  $PLAT_THIRD_PARTY_DIR/hdf5;echo "hdf5 ln deleted" ;fi
ln -s ${PLAT_THIRD_PARTY_DIR}/salome/${SALOME_HDF5_DIR}       $PLAT_THIRD_PARTY_DIR/hdf5; 
echo $SCRIPT_NAME " 3a link -> hdf5 from "$PLAT_THIRD_PARTY_DIR/salome/$SALOME_HDF5_DIR  "to" $PLAT_THIRD_PARTY_DIR/hdf5 

if [ -L $PLAT_THIRD_PARTY_DIR/med ];  then   rm -r  $PLAT_THIRD_PARTY_DIR/med ;echo "med ln deleted" ;fi 
ln -s $PLAT_THIRD_PARTY_DIR/salome/$SALOME_med_dir  $PLAT_THIRD_PARTY_DIR/med      ;
echo $SCRIPT_NAME " 3a link -> salome/med from "  $PLAT_THIRD_PARTY_DIR/salome/$SALOME_med_dir "to" $PLAT_THIRD_PARTY_DIR/med      ;
   
if [ -L $PLAT_THIRD_PARTY_DIR/MED_mod ];  then rm -r  $PLAT_THIRD_PARTY_DIR/MED_mod ;echo "MED_mod ln deleted" ;fi
ln -s ${PLAT_THIRD_PARTY_DIR}/salome/${SALOME_MED_DIR}        ${PLAT_THIRD_PARTY_DIR}/MED_mod ; 
echo $SCRIPT_NAME " 3a link -> salome/MED_mod from " $PLAT_THIRD_PARTY_DIR/salome/$SALOME_MED_DIR "to " $PLAT_THIRD_PARTY_DIR/MED_mod ; 
 
if [ -L $PLAT_THIRD_PARTY_DIR/MED_coupling ];  then rm -r  $PLAT_THIRD_PARTY_DIR/MED_coupling ;echo "MED_coupling ln deleted" ;fi
ln -s  $PLAT_THIRD_PARTY_DIR/salome/$SALOME_MED_COUPL_DIR $PLAT_THIRD_PARTY_DIR/MED_coupling    ; 
echo $SCRIPT_NAME " 3a link -> salome/MED_coupling from" $PLAT_THIRD_PARTY_DIR/salome/$SALOME_MED_COUPL_DIR "to" $PLAT_THIRD_PARTY_DIR/MED_coupling; 

rm ${DOWNLOAD_PKG}_public.run

# 0 ##################################################################################################
fi

# https://www.salome-platform.org/forum/forum_12/711766742
# The sources of MEDReader can be found into[PARAVIS_SRC]/src/Plugins/MedReader.
# If you want to use the plugin in a standard install of paraview, you need:
# - Paraview V3.10
# - To have the following libraries accessible in a directory defined by PV_PLUGIN_PATH:
# * [PARAVIS_INSTALL_DIR]/lib/paraview/libMedReaderPlugin.so
# * [PARAVIS_INSTALL_DIR]/lib/paraview/libParaMEDCorbaPlugin.so
# * [PARAVIS_INSTALL_DIR]/lib/paraview/libELNOFilter.so
# - To have the MED libraries (V3) accessible in a directory defined by LD_LIBRARY_PATH
# The libraries can be copied from an install of Salome 6.3.1:
# For Paraview plugin libs : PARAVIS_INSTALL_DIR = [SALOME_DIR]/SALOME6/V6_3_1/PARAVIS_V6_3_1/
# For MED the libs are in : [SALOME_DIR]/SALOME6/tools/Med-303hdf5184/lib
