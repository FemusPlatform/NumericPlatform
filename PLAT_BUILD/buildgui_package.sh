
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
        "salome"           "$salome_ver"        off \
        "openmpi"          "$openmpi_ver"       off \
        "petsc"            "$petsc_ver"         off \
        "med"              "$med_ver"           off \
        "medcoupling"      "$medcoupling_ver"   off \
        "gmsh"             "4.2.2"              off \
        "qhull"            "2015.2"             off \
        "lapack"           "3.8.0"              off \
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
# clear
    
for word in $choice; do 
 
name_ver=$(echo '$'"$word"_name_ver)
name_pck=$(echo '$'"$word"_name_pck)
name_script=$(echo '$'"$word".sh) 

cd $BUILD_DIR      
export INSTALL_DIR=$PLAT_THIRD_PARTY_DIR
    source install_scripts/package.sh $word
    dialog --title "Done installing" --msgbox " Package $word  is installed " 10 50

done
# dialog --title "Done installation" --msgbox "you have installed: $choice" 8 30

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
        "libmesh"          "$libmesh_ver"  off  \
        "femus"            "$femus_ver"     off  \
        "dragondonjon"     "$dragondonjon_ver"  off  \
        "openfoam"         "$openfoam_ver" off \
        "getfem"           "$getfem_ver" off 2> $tempfile
        
        
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
 
cd $BUILD_DIR
export INSTALL_DIR=$PLAT_CODES_DIR

name_ver=$(echo '$'"$word"_name_ver)
name_pck=$(echo '$'"$word"_name_pck)
name_script=$(echo '$'"$word".sh)

  dialog --title "Installing scripting $word.sh " --msgbox " name package $word "  10 50
    source install_scripts/package.sh  $word
  dialog --title "Done installing" --msgbox " Package $word  is installed  " 10 50
 


done
# dialog --title "Done installation" --msgbox "you have installed: $choice" 8 30
} 



