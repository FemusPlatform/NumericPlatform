source buildgui_vers.sh
source install_scripts/package_fun.sh
# ##################################################################################################
# Install OpenMPI
# source install_scripts/package.sh  openmpi
# --------------------------------------------------------------------------------------------------
# This file script should be placed inside .../platform/plat_installation ($BUILD_DIR) and
# the tar.gz package in the packages_targz dir ($BUILD_DIR/packages_targz)
# ############################################################################################################

# ==========================================================================================================
# 1) Setup =================================================================================================
# ==========================================================================================================
 # ==========================================================================================================
name=$1
name_ver=$(eval echo '$'"$name"_ver)
name_pck=$(eval echo '$'"$name"_name_pck)
name_download=$(eval echo '$'"$name"_name_download)


# print directory and pathname
check_plat $1
echo "name $name"
echo "name_ver $name_ver"
echo "name_pck $name_pck"
echo "name_download $name_download"
  # ===========================================================================================================
  # 2) Install OpenMPI script  ================================================================================
  # ===========================================================================================================
  cd $BUILD_DIR
   echo $INSTALL_DIR/${name_pck}
 echo  $PLAT_BUILD_TAR_DIR/$name_download

     # CHECK EXISTANCE OF SOURCE ZIPPED PACKAGE
     if [ ! -f $PLAT_BUILD_TAR_DIR/$name_download ] ; then
          dialog --msgbox "Attention!! Please download $PLAT_BUILD_TAR_DIR/$name_download from the download section" 10 50
        return
     fi
    #if dir  targz package exists ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    if [ ! -d $INSTALL_DIR/${name_pck} ]; then echo ${name} ": 2 -> 2b configure-> 2c make-> 2d install"

     #  uncompress the tar.gz file if needed --------------------------------------------------------------------
     if [ ! -d $name_pck ]; then  echo " extracted file: $PLAT_BUILD_TAR_DIR/$name_download "
        pre_tar $name $name_pck
        run_tar  $name_download
        post_tar  $name $name_pck
     fi
     cd $BUILD_DIR/$name_pck



     # 2b configure ---------------------------------------------------------------------------------------------
     echo ${name} ": 2b starting configure command"

     pre_configure $name $name_pck
     run_configure $name
     post_configure $name_pck


     # 2c compiling ---------------------------------------------------------------------------------------------
     echo ${name} ": 2c Configuration ended, now compiling"
     pre_compile $name $name_pck
     run_compile  $name $name_pck
     post_compile $name


     # 2d make install ------------------------------------------------------------------------------------------
     echo ${name} ": 2d Compilation ended now installing"
     pre_install $name
     run_install $name $name_pck
     post_install $name

     echo ${name} ": successfully installed! in " $BUILD_DIR/$name_pck
  # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  else
     echo;
     echo ${name} ": 2 No installation, directory already exists: only linking "
  fi
  # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#   # ============================================================================================================
#   # 3 post install =============================================================================================
#   # ============================================================================================================


 cd $BUILD_DIR
  if [ "$?" != "0" ];then echo -e "3a ${red}ERROR! installation dir not here ${NC}";exit 1;
  fi
#
  echo; echo ${name} " 3 -> 3a links -> 3b ${name} usage commands"
  # 3a link ----------------------------------------------------------------------------------------------------

  echo " 3a ln -s $INSTALL_DIR/${name_pck}   $INSTALL_DIR/${name}"
  link_install $name_pck  $name
  echo "link_lib_lib64 $INSTALL_DIR/${name}/lib  $INSTALL_DIR/${name}/lib64 "
  link_lib_lib64 $name

  post_link $name

