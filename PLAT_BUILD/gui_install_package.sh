source install_scripts/code_versions.sh

function show_platform(){
  source install_scripts/platform.sh 
  dialog --title "Done preparing" --msgbox " Platform structure has been configured " 10 50
} 

function show_third_packages(){

: ${DIALOG=dialog}
: ${DIALOG_OK=0}
: ${DIALOG_CANCEL=1}
: ${DIALOG_EXTRA=3}
: ${DIALOG_ESC=255}
tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$
trap "rm -f $tempfile" 0 1 2 5 15

$DIALOG --backtitle "Software platform" \
	--title "Third Party Packages" \
	--extra-button --extra-label "Fast" \
    --checklist "
  Press SPACE to toggle an option on/off. \n\n\
  Check on the package to install \n\n\
  Please install the packages with the proposed following order" 20 61 10 \
        "SALOME"           "$SalomeLast" off  \
        "openmpi"          "$OpenmpiLast"  off  \
        "petsc-dbg"        "$PetscLast" off  \
        "petsc-opt"        "$PetscLast" off  \
        "med"              "4.0.0"  off  \
        "medCoupling"      "9.2.0"  off  \
        "gmsh"             "4.2.2"  off  \
        "qhull"            "2015.2" off  \
        "lapack"           "3.8.0" off \
        2> $tempfile

retval=$?
# choice=`cat $tempfile`
choice=` sed s/\"//g  $tempfile`
more  $tempfile
fast=no
case $retval in
    $DIALOG_OK)
     echo "'$choice' chosen.";;
    $DIALOG_EXTRA)
     fast=yes;;
    $DIALOG_CANCEL)
     echo "Cancel pressed.";;
    $DIALOG_ESC)
     echo "ESC pressed.";;
   *)
    echo "Unexpected return code: $retval (ok would be $DIALOG_OK)";;
esac  

    
for word in $choice; do 

# SALOME ----------------------------------------------------------------------------
 if [ $word == 'SALOME'  ]; then
   export SalomeOption=$SalomeLast 
   if [ $fast == 'no' ]; then 
     dialog --title "requirements" --msgbox " SALOME required packages: none " 10 50
   fi
   clear
   cd $BUILD_DIR
   source install_scripts/salome9.sh $SalomeOption
   if [ $fast == 'no' ]; then 
     dialog --title "Done installing" --msgbox " SALOME is installed" 10 50
   fi
 fi
 
 
# OPENMPI --------------------------------------------------------------------------------------------  
 if [ $word == 'openmpi'  ]; then
   export OpenmpiOption=$OpenmpiLast
   export COMPLETED=0
   if [ $fast == 'no' ]; then 
     dialog --title "requirements" --msgbox " OpenMPI required packages: none " 10 50
   fi
   clear
   cd $BUILD_DIR
   source install_scripts/openmpi.sh $OpenmpiOption
   if [ $COMPLETED == '0' ]; then
     if [ $fast == 'no' ]; then 
       dialog --title "Done installing" --msgbox " OpenMPI is installed" 10 50
     fi
   else
     dialog --title "Unable to install" --msgbox " For details check logs in \n $INSTALL_PLAT_LOG_DIR \n directory" 10 50
     clear
     return
   fi
 fi
 
 
# PETSC-DBG --------------------------------------------------------------------------------------------   
 if [ $word == 'petsc-dbg'  ]; then
   export PetscOption
   export COMPLETED=0
   if [ $fast == 'no' ]; then 
      dialog --clear  --backtitle " Platform installer " \
       --title "[ PETSC VERSION ]" \
       --menu "Which PETSC version to install" 10 70 2 \
       Latest       "Use latest available version of PETSC, git repository" \
       LastWorking  "Use last known working version of PETSC $PetscLast" 2>"${INPUT}"
       menuitem=$(<"${INPUT}")

       case $menuitem in
        Latest) PetscOption=$PetscLatest;;
        LastWorking) PetscOption=$PetscLast ;;
       esac
     dialog --title "requirements" --msgbox " PETSC required packages: OpenMPI " 10 50
   fi
   if [ $fast == 'yes' ]; then 
     PetscOption=$PetscLast 
   fi
   clear
   cd $BUILD_DIR
   source install_scripts/petsc_dbg.sh $PetscOption
   if [ $COMPLETED == '0' ]; then
     if [ $fast == 'no' ]; then 
       dialog --title "Done installing" --msgbox " PETSC is installed" 10 50
     fi
   else
     dialog --title "Unable to install" --msgbox " For details check logs in \n $INSTALL_PLAT_LOG_DIR \n directory" 10 50
     clear
     return
   fi
 fi
 
 
# PETSC-OPT --------------------------------------------------------------------------------------------   
 if [ $word == 'petsc-opt'  ]; then
   export PetscOption
   export COMPLETED=0
   if [ $fast == 'no' ]; then 
      dialog --clear  --backtitle " Platform installer " \
       --title "[ PETSC VERSION ]" \
       --menu "Which PETSC version to install" 10 70 2 \
       Latest       "Use latest available version of PETSC, git repository" \
       LastWorking  "Use last known working version of PETSC $PetscLast" 2>"${INPUT}"
       menuitem=$(<"${INPUT}")

       case $menuitem in
        Latest) PetscOption=$PetscLatest;;
        LastWorking) PetscOption=$PetscLast ;;
       esac
     dialog --title "requirements" --msgbox " PETSC required packages: OpenMPI " 10 50
   fi
   if [ $fast == 'yes' ]; then 
     PetscOption=$PetscLast 
   fi
   clear
   cd $BUILD_DIR
   source install_scripts/petsc_opt.sh $PetscOption
   if [ $COMPLETED == '0' ]; then
     if [ $fast == 'no' ]; then 
       dialog --title "Done installing" --msgbox " PETSC is installed" 10 50
     fi
   else
     dialog --title "Unable to install" --msgbox " For details check logs in \n $INSTALL_PLAT_LOG_DIR \n directory" 10 50
     clear
     return
   fi
 fi
 
 
# MED --------------------------------------------------------------------------------------------
 if [ $word == 'med'  ]; then
   export COMPLETED=0
   if [ $fast == 'no' ]; then 
     dialog --title "requirements" --msgbox " med required packages: none " 10 50
   fi
   clear
   cd $BUILD_DIR
   source install_scripts/med4.sh 4.0.0
   if [ $COMPLETED == '0' ]; then
     if [ $fast == 'no' ]; then 
       dialog --title "Done installing" --msgbox " med is installed" 10 50
     fi
   else
     dialog --title "Unable to install" --msgbox " For details check logs in \n $INSTALL_PLAT_LOG_DIR \n directory" 10 50
     clear
     return
   fi
 fi
 
 
# MED_coupling -------------------------------------------------------------------------------------------- 
 if [ $word == 'medCoupling'  ]; then
   export COMPLETED=0
   if [ $fast == 'no' ]; then 
     dialog --title "requirements" --msgbox " medCoupling required packages: none " 10 50
   fi
   clear
   cd $BUILD_DIR
   source install_scripts/medCoupling9.sh 9.2.0 
   if [ $COMPLETED == '0' ]; then
     if [ $fast == 'no' ]; then 
       dialog --title "Done installing" --msgbox " medCoupling is installed" 10 50
     fi
   else
     dialog --title "Unable to install" --msgbox " For details check logs in \n $INSTALL_PLAT_LOG_DIR \n directory" 10 50
     clear
     return
   fi
 fi
 
 
 # GMSH -------------------------------------------------------------------------------------------- 
 if [ $word == 'gmsh'  ]; then
   export COMPLETED=0
   if [ $fast == 'no' ]; then 
     dialog --title "requirements" --msgbox " med " 10 50
   fi
   clear
   cd $BUILD_DIR
   source install_scripts/gmsh.sh 4.2.2 
   if [ $COMPLETED == '0' ]; then
     if [ $fast == 'no' ]; then 
       dialog --title "Done installing" --msgbox " GMSH is installed" 10 50
     fi
   else
     dialog --title "Unable to install" --msgbox " For details check logs in \n $INSTALL_PLAT_LOG_DIR \n directory" 10 50
     clear
     return
   fi
 fi
 
 # QHULL -------------------------------------------------------------------------------------------- 
 if [ $word == 'qhull'  ]; then
   export COMPLETED=0
   clear
   cd $BUILD_DIR
   source install_scripts/qhull.sh 
   if [ $COMPLETED == '0' ]; then
     if [ $fast == 'no' ]; then 
       dialog --title "Done installing" --msgbox " QHULL is installed" 10 50
     fi
   else
     dialog --title "Unable to install" --msgbox " For details check logs in \n $INSTALL_PLAT_LOG_DIR \n directory" 10 50
     clear
     return
   fi
 fi
 
 # LAPACK -------------------------------------------------------------------------------------------- 
 if [ $word == 'lapack'  ]; then
   export COMPLETED=0
   clear
   cd $BUILD_DIR
   source install_scripts/lapack.sh 
   if [ $COMPLETED == '0' ]; then
     if [ $fast == 'no' ]; then 
       dialog --title "Done installing" --msgbox " LAPACK is installed" 10 50
     fi
   else
     dialog --title "Unable to install" --msgbox " For details check logs in \n $INSTALL_PLAT_LOG_DIR \n directory" 10 50
     clear
     return
   fi
 fi 
 
 
 

done
dialog --title "Done installation" --msgbox "you have installed: $choice" 8 30

} 

function show_codes(){

        
: ${DIALOG=dialog}
: ${DIALOG_OK=0}
: ${DIALOG_CANCEL=1}
: ${DIALOG_EXTRA=3}
: ${DIALOG_ESC=255}
tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$
trap "rm -f $tempfile" 0 1 2 5 15

$DIALOG --backtitle "Software platform" \
	--title "Third Party Packages" \
	--extra-button --extra-label "Fast" \
    --checklist "
  Press SPACE to toggle an option on/off. \n\n\
  Check on the numerical code to install " 20 61 10 \
        "Libmesh"          "$LibmeshLast"  off  \
        "FEMUs"            "v0"     off  \
        "DragonDonjon"     "v5.02"  off  \
        "OpenFOAM"         "Extend 4.0" off \
        "getfem"           "5.3" off 2> $tempfile
        
        
retval=$?
# choice=`cat $tempfile`
choice=` sed s/\"//g  $tempfile`
more  $tempfile
fast=no
case $retval in
    $DIALOG_OK)
     echo "'$choice' chosen.";;
    $DIALOG_EXTRA)
     fast=yes;;
    $DIALOG_CANCEL)
     echo "Cancel pressed.";;
    $DIALOG_ESC)
     echo "ESC pressed.";;
   *)
    echo "Unexpected return code: $retval (ok would be $DIALOG_OK)";;
esac  

    
for word in $choice; do 
# LIBMESH -------------------------------------------------------------------------------------------- 
 if [ $word == 'Libmesh' ]; then
   export LibmeshOption
   if [ $fast == 'no' ]; then 
      dialog --clear  --backtitle " Platform installer " \
       --title "[ LIBMESH VERSION ]" \
       --menu "Which LIBMESH version to install" 10 70 2 \
       Latest       "Use latest available version of LIBMESH, git repository" \
       LastWorking  "Use last known working version of LIBMESH $LibmeshLast" 2>"${INPUT}"
       menuitem=$(<"${INPUT}")

       case $menuitem in
        Latest) LibmeshOption=$LibmeshLatest;;
        LastWorking) LibmeshOption=$LibmeshLast ;;
       esac
     dialog --title "requirements" --msgbox " LIBMESH required packages: OPENMPI, PETSC " 10 50
   fi
   if [ $fast == 'yes' ]; then 
     LibmeshOption=$LibmeshLast 
   fi
   clear
   cd $BUILD_DIR
   source install_scripts/libmesh.sh $LibmeshOption
   if [ $fast == 'no' ]; then 
     dialog --title "Done installing" --msgbox " LIBMESH is installed" 10 50
   fi
 fi

# FEMUS -------------------------------------------------------------------------------------------- 
 if [ $word == 'FEMUs'  ]; then
   if [ $fast == 'no' ]; then 
     dialog --title "requirements" --msgbox " FEMUs required packages: OPENMPI, PETSC, LIBMESH" 10 50
   fi
   clear
   cd $BUILD_DIR
   source install_scripts/femus.sh
   if [ $fast == 'no' ]; then 
     dialog --title "Done installing" --msgbox " FEMUs is installed" 10 50
   fi
 fi
 
# DRAGON_DONJON --------------------------------------------------------------------------------------------       
 if [ $word == 'DragonDonjon' ]; then
   if [ $fast == 'no' ]; then 
     dialog --title "requirements" --msgbox " DragonDonjon required packages: none" 10 50
   fi
   clear
   cd $BUILD_DIR
   source install_scripts/dragondonjon.sh
   dialog --title "Done installing" --msgbox " DragonDonjon is installed" 10 50
 fi
 
# OPENFOAM -------------------------------------------------------------------------------------------- 
 if [ $word == 'OpenFOAM'  ]; then
   if [ $fast == 'no' ]; then
     dialog --title "requirements" --msgbox " OPENFOAM required packages: OPENMPI " 10 50
   fi
   clear
   cd $BUILD_DIR
   source install_scripts/foam_repo.sh
   if [ $fast == 'no' ]; then
     dialog --title "Done installing" --msgbox " OPENFOAM is installed" 10 50
   fi
 fi
 
# GETFEM -------------------------------------------------------------------------------------------- 
 if [ $word == 'getfem'  ]; then
   if [ $fast == 'no' ]; then
     dialog --title "requirements" --msgbox " GETFEM required packages: qhull, lapack " 10 50
   fi
   clear
   cd $BUILD_DIR
   source install_scripts/getfem.sh
   if [ $fast == 'no' ]; then
     dialog --title "Done installing" --msgbox " GETFEM is installed" 10 50
   fi
 fi

done
dialog --title "Done installation" --msgbox "you have installed: $choice" 8 30
} 

