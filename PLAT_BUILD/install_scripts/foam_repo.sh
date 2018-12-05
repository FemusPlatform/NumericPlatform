##############################################################################
#System preparations process for OpenSuse - see also http://openfoamwiki.net/index.php/Installation/Linux/foam-extend-$1/openSUSE
#
#sudo -s
#zypper install -t pattern devel_C_C++
#zypper install cmake libqt4-devel qt4-x11-tools qt4-assistant-adp-devel gnuplot openmpi-devel boost-devel cgal-devel gmp-devel mpfr-devel libQtWebKit-devel python-devel git mercurial rpm-build
#exit
##############################################################################

#  Installation organized as follows
#   
#  $MYHOME/                            platform base directory
#    -$MYPREFIXDIR/                      installation directory
#       -foam-extend-foam-extend-4.0       installed packages
#       -petsc-3.8.3                       .
#       -openmpi-3.0.0                     .
#       -...                               .
#       -packages_logs                     package installation logs
#
#
#    -foam/                              base foam operative folder
#      -foam-extend-4.0                    linked folder from installed package
#      -foam-extend-3.1                    .
 
# RUN FROM plat_repo
 
echo 
echo " --------- Start foam.sh script : from install_plat dir -------- "
echo
export VERSION=4.0
# main operative folder
export FOAM_MAIN=foam
# linked foam project
export LN_FOAM_PROJ=foam-extend-$VERSION
# download from git
export PKG_NAME=foam-extend-foam-extend-$VERSION

# check whether $MYHOME/foam directory exists or not
if [ ! -d "$PLAT_CODES_DIR/$FOAM_MAIN" ] 
  then
  mkdir $PLAT_CODES_DIR/$FOAM_MAIN
fi

cd $PLAT_CODES_DIR/$FOAM_MAIN
    
    export LOGDIR=$BUILD_DIR/package_logs/

    echo "foam installing in " $PWD
    
    echo
    echo " --------- Getting foam from git --------- "
    echo
    git clone https://github.com/FemusPlatform/$PKG_NAME.git $PLAT_CODES_DIR/$FOAM_MAIN/$LN_FOAM_PROJ
    echo
    echo " --------- End download, starting configuration --------- "
    echo
    
    cd $PLAT_CODES_DIR/$FOAM_MAIN/$LN_FOAM_PROJ
    
    echo unset WM_THIRD_PARTY_USE_CMAKE_322 >> $PLAT_CODES_DIR/$FOAM_MAIN/$LN_FOAM_PROJ/etc/prefs.sh
    echo export WM_MPLIB=SYSTEMOPENMPI >> $PLAT_CODES_DIR/$FOAM_MAIN/$LN_FOAM_PROJ/etc/prefs.sh
    cd etc
    
    sed -e "38s|.*|export MainDir=\\$\PLAT_CODES_DIR|" bashrc>bashrc_temp
    sed -e "50s|.*|foamInstall=\\$\MainDir/\\$\WM_PROJECT|" bashrc_temp>bashrc_temp1
    sed -e "66s|.*|export FOAM_INST_DIR=\\$\MainDir/\\$\WM_PROJECT|" bashrc_temp1>bashrc
     
    rm bashrc_temp
    rm bashrc_temp1
    
    echo
    echo " --------- End configuration, now compile --------- "
    echo
    echo $PWD
    
    ##
    # path to openmpi must be set before source bashrc 
    ##
    echo "-----------------------------------------------------------------"
    echo " Setting path to openmpi in order to compile with platform openmpi "
    echo "-----------------------------------------------------------------"
    
    # unset foam variables
    unset OPENMPI_INCLUDE_DIR
    unset OPENMPI_COMPILE_FLAGS
    unset OPENMPI_LINK_FLAGS
    
    # load platform mpi
    export PATH=$PLAT_THIRD_PARTY_DIR/openmpi/bin/:$PATH
    export LD_LIBRARY_PATH=$PLAT_THIRD_PARTY_DIR/openmpi/lib64/:$LD_LIBRARY_PATH
    export LD_LIBRARY_PATH=$PLAT_THIRD_PARTY_DIR/openmpi/lib/:$LD_LIBRARY_PATH
    
    echo "openmpi include dirs " "`mpicc --showme:incdirs`"
    echo "openmpi library dirs " "`mpicc --showme:libdirs`"
    echo "openmpi link dirs    " "`mpicc --showme:linkdirs`"
    
    read -p "Press any key to continue... " -n1 -s
    echo 
    
    source bashrc
    
    
    echo "alias fe40='export MYHOME=$PLAT_CODES_DIR && source $PLAT_CODES_DIR/$FOAM_MAIN/$LN_FOAM_PROJ/etc/bashrc'" >> ~/.bashrc
    cd ..
    sed -i -e 's=\-L$(OPENMPI.*=$(PLIBS)=' $FOAM_SRC/decompositionMethods/parMetisDecomp/Make/options
    
    #set environment variable for Qt to compile ParaView and add it to the respective preferences shell file:
    export QT_BIN_DIR=/usr/bin/qmake
    echo "export QT_BIN_DIR=$QT_BIN_DIR" >> etc/prefs.sh
    
    
    echo
    echo " --------- START INSTALLATION --------- "
    echo
    
    # wmake is required for subsequent targets
    cd wmake/src  
    make 
     
    # build ThirdParty sources
    cd $WM_THIRD_PARTY_DIR 
    echo "WM_THIRD_PARTY_DIR" $WM_THIRD_PARTY_DIR
    # run from third-party directory only
    #  cd ${0%/*} || exit 1
    # 
     wmakeCheckPwd "$WM_THIRD_PARTY_DIR" || {
         echo "Error: Current directory is not \$WM_THIRD_PARTY_DIR"
         echo "    The environment variables are inconsistent with the installation."
         echo "    Check the foam-extend entries in your dot-files and source them."
    #      exit 1
     }
     . tools/makeThirdPartyFunctionsForRPM
     #------------------------------------------------------------------------------
    
    echo ========================================
    echo Starting ThirdParty Allwmake.pre
    echo ========================================
    echo
    
    mkdir $LOGDIR/foam_logs
    rm $LOGDIR/foam_logs/*
    
    export FOAM_LOGS=$LOGDIR/foam_logs/
    
    # Running stage 0 (only if RPM filenames are supplied on the command line)
    [ "$#" -gt 0 ] && {
        ./AllMake.stage0 "$@"
        shift "$#"
    }
    
    echo  "Check OPENMPI environment "
    echo  "OPENMPI_BIN_DIR   "       $OPENMPI_BIN_DIR            >& $FOAM_LOGS/foam_mpi_config.log 
    echo
    echo  "OPENMPI_INCLUDE_DIR   "   $OPENMPI_INCLUDE_DIR        >& $FOAM_LOGS/foam_mpi_config.log 
    echo
    echo  "OPENMPI_COMPILE_FLAGS "   $OPENMPI_COMPILE_FLAGS      >& $FOAM_LOGS/foam_mpi_config.log 
    echo
    echo  "OPENMPI_LINK_FLAGS    "   $OPENMPI_LINK_FLAGS         >& $FOAM_LOGS/foam_mpi_config.log 
    
    
    echo ========================================
    echo "Running stage 1"
    ./AllMake.stage1  >& $FOAM_LOGS/foam_install_s1.log 
    
    echo ========================================
    echo "Running stage 2"
    ./AllMake.stage2  >& $FOAM_LOGS/foam_install_s2.log
    
    echo ========================================
    echo "Running stage 3"
    ./AllMake.stage3  >& $FOAM_LOGS/foam_install_s3.log
    
    echo ========================================
    echo "Running stage 4"
    ./AllMake.stage4  >& $FOAM_LOGS/foam_install_s4.log
    
    
    echo ========================================
    echo Done ThirdParty Allwmake.pre
    echo ========================================
    echo
    
    # We make sure the ThirdParty packages environment variables are up-to-date
    # before compiling the rest of OpenFOAM
    . $WM_PROJECT_DIR/etc/settings.sh
    
    cd $PLAT_CODES_DIR/$FOAM_MAIN/$LN_FOAM_PROJ
    
    # build OpenFOAM libraries and applications
    echo ========================================
    echo "Building src ....  "
    src/Allwmake >& $FOAM_LOGS/foam_install_src.log
    echo "Applications ....  "
    applications/Allwmake >& $FOAM_LOGS/foam_install_app.log
    echo ========================================
    echo "Doc ....  "
    if [ "$1" = doc ]
    then
        doc/Allwmake
    fi
    
    # build ThirdParty sources that depend on main installation
    export WM_NCOMPPROCS=1
    cd $WM_THIRD_PARTY_DIR  
    ./AllMake.post  >& $FOAM_LOGS/foam_install_post.log
    
    # Build extend-bazaar packages
    #( cd extend-bazaar && ./Allwmake)
    
    # # ./Allwmake.firstInstall
    # Now create a run directory and copy all the tutorials to it
    echo
    echo " --------- Post Installation --------- "
    echo
    cd ..
    export FOAM_RUN=$PLAT_CODES_DIR/$FOAM_MAIN/$USER-$VERSION/run
    mkdir -p $FOAM_RUN
    cp -r $FOAM_TUTORIALS $FOAM_RUN




