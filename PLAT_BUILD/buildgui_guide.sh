function show_guide(){
	
	
: ${DIALOG=dialog}
: ${DIALOG_OK=0}
: ${DIALOG_CANCEL=1}
: ${DIALOG_ESC=255}
tempfiled=`tempfiled 2>/dev/null` || tempfiled=/tmp/test$$
trap "rm -f $tempfiled" 0 1 2 5 15

$DIALOG --backtitle "Software platform download" \
	--title "Download packages" \
        --checklist "
Press SPACE to toggle an option on/off. \n\n\
  Check on the package to Dowload" 23 50 13 \
        "SALOME"           "V7_7_1" off  \
        "openmpi"          "1.10.2" off  \
        "fblaslapack"      "3.4.2" off \
        "petsc"            "3.7.0"  off  \
        "libmesh"          "0.9.5"  off  \
        "FEMUs"            "v0"     off  \
        "Paraview"         " "      off  \
        "DragonDonjon"     "v5.02"  off \
        "ParaFOAM"         "4.01"   off  \
        "OPENFOAM"         "3.01"   off  \
        "Saturne"          "4.0.5 " off \
        "GUITHARE"          "1.8.5 " off \
        "CATHARE"          " "       off  2> $tempfiled

retvald=$?
choiced=`cat $tempfiled`
more  $tempfiled
case $retvald in
    $DIALOG_OK)
     echo "'$choiced' chosen.";;
    $DIALOG_CANCEL)
     echo "Cancel pressed.";;
    $DIALOG_ESC)
     echo "ESC pressed.";;
   *)
    echo "Unexpected return code: $retvald (ok would be $DIALOG_OK)";;
esac 

msg_dialog=""
# msg_dialog10=""

for word in $choiced; do 

 # SALOME 7.7.1 ---------------------------------------------------------------------------------------------
 if [ $word == 'SALOME' ]; then
 dialog --title "Guide" --msgbox "  not available" 10 50
 fi
 if [ $word == 'Paraview' ]; then
dialog --title "Guide" --msgbox "  not available" 10 50
 fi
 # Openmpi  1.10.2 ------------------------------------------------------------------------------------------
 if [ $word == 'openmpi' ]; then
 dialog --title "Guide" --msgbox "  not available" 10 50
 fi
 # PETSC  3.7.0 ---------------------------------------------------------------------------------------------
 if [ $word == 'fblaslapack' ]; then
    dialog --title "Guide" --msgbox "  not available" 10 50
 fi
 # PETSC  3.7.0 ---------------------------------------------------------------------------------------------
 if [ $word == 'petsc' ]; then
     dialog --title "Guide" --msgbox "  not available" 10 50
 fi
#  libmesh.sh 0.9.5 -----------------------------------------------------------------------------------------
 if [ $word == 'libmesh' ]; then
     dialog --title "Guide" --msgbox "  not available" 10 50
 fi
 # femus ----------------------------------------------------------------------
 if [ $word == 'FEMUs' ]; then
 dialog --title "Guide" --msgbox "  not available" 10 50
 fi
 # DragonDonjon v5.0.2 ---------------------------------------------------------------------------------------
 if [ $word == 'DragonDonjon' ]; then
      dialog --title "Installation Guide" --textbox   ./doc/donjon.txt 20 90
 fi
 # ParaviewFoam ---------------------------------------------------------------
 if [ $word == 'ParaFOAM' ]; then
     dialog --title "Guide" --msgbox "  not available" 10 50
 fi
 # Open foam OpenFOAM-v3.0+ ---------------------------------------------------
 if [ $word == 'OPENFOAM' ]; then
    dialog --title "Guide" --msgbox "  not available" 10 50
 fi
  # Saturne  ---------------------------------------------------
 if [ $word == 'Saturne' ]; then
    dialog --title "Guide" --msgbox "  not available" 10 50
 fi
 
 
 if [ $word == 'CATHARE'  ]; then
   dialog --title "Intallation Guide" --textbox   ./doc/cathare.txt 20 90
 fi
      
if [ $word == 'GUITHARE'  ]; then
   dialog --title "Installation Guide" --textbox   ./doc/guithare.txt 20 90
fi
done	
} 
