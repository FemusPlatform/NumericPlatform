function show_dowloading(){
	
	
: ${DIALOG=dialog}
: ${DIALOG_OK=0}
: ${DIALOG_CANCEL=1}
: ${DIALOG_EXTRA=3}
: ${DIALOG_ESC=255}
tempfiled=`tempfiled 2>/dev/null` || tempfiled=/tmp/test$$
trap "rm -f $tempfiled" 0 1 2 5 15

$DIALOG --backtitle "Software platform download" \
        --extra-button --extra-label "Fast" \
	--title "Download packages" \
        --checklist "
Press SPACE to toggle an option on/off. \n\n\
  Check on the package to Dowload" 23 50 13 \
        "med"              "4.0.0"   ON  \
        "medCoupling"      "9.2.0"   ON  \
        "SALOME"           "9_2_0"   ON  \
        "openmpi"          "3.1.3"   ON  \
        "fblaslapack"      "3.4.2"   ON  \
        "petsc"            "3.10.2"  ON  \
        "libmesh"          "1.3.1"   ON  \
        "FEMUs"            "v0"      ON  \
        "libmeshcpp"       "v0"      off \
        "Paraview"         " "       off \
        "DragonDonjon"     "v5.02"   off \
        "ParaFOAM"         "4.01"    off \
        "OPENFOAM"         "3.01"    off \
        "Saturne"          "4.0.5 "  off 2> $tempfiled

retvald=$?
#choiced=`cat $tempfiled`
choiced=` sed s/\"//g  $tempfiled`
more  $tempfiled
fast=no
case $retvald in
    $DIALOG_OK)
     echo "'$choiced' chosen.";;
    $DIALOG_EXTRA)
     fast=yes;;
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

 # SALOME 9.2.0 ---------------------------------------------------------------------------------------------
 if [ $word == 'SALOME' ]; then
 if [ $fast == 'no' ]; then 
 dialog --title "Downloading SALOME" --msgbox "Now we are downloading SALOME: no other packages required " 10 50 
 fi
   wget --progress=dot 'https://www.salome-platform.org/downloads/current-version/DownloadDistr?platform=UniBinNew2&version=9.2.0_64bit' \
   2>&1 | grep "%" | sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e "s,\%,,g" \
   | dialog --gauge "We are downloading SALOME" 10 100
   if [ $fast == 'no' ]; then 
   dialog --title "Done downloading" --msgbox "Salome-V9_2_0.run.tar.gz dowloaded from https://www.salome-platform.org/downloads" 10 50
    fi
    mv DownloadDistr?platform=UniBinNew2\&version=9.2.0_64bit packages_targz/Salome-V9.2.0-univ_public.run
#    echo 
 fi
  # med 4.0.0 ---------------------------------------------------------------------------------------------
 if [ $word == 'med' ]; then
 if [ $fast == 'no' ]; then 
 dialog --title "Downloading med" --msgbox "Now we are downloading med: no other packages required " 10 50 
 fi
   wget --progress=dot files.salome-platform.org/Salome/other/med-4.0.0.tar.gz \
   2>&1 | grep "%" | sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e "s,\%,,g" \
   | dialog --gauge "We are downloading med" 10 100
   if [ $fast == 'no' ]; then 
   dialog --title "Done downloading" --msgbox "med-4.0.0.tar.gz dowloaded from files.salome-platform.org/Salome/other/med-4.0.0.tar.gz" 10 50
    fi
    mv med-4.0.0.tar.gz packages_targz/med-4.0.0.tar.gz
#    echo 
 fi
   # MED_coupling 9.2.0 ---------------------------------------------------------------------------------------------
 if [ $word == 'medCoupling' ]; then
 if [ $fast == 'no' ]; then 
 dialog --title "Downloading medCoupling" --msgbox "Now we are downloading medCoupling no other packages required " 10 50 
 fi
   wget --progress=dot files.salome-platform.org/Salome/other/medCoupling-9.2.0.tar.gz \
   2>&1 | grep "%" | sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e "s,\%,,g" \
   | dialog --gauge "We are downloading medCoupling" 10 100
   if [ $fast == 'no' ]; then 
   dialog --title "Done downloading" --msgbox "medCoupling-9.2.0.tar.gz dowloaded from files.salome-platform.org/Salome/other/medCoupling-9.2.0.tar.gz" 10 50
    fi
    mv medCoupling-9.2.0.tar.gz packages_targz/medCoupling-9.2.0.tar.gz
#    echo 
 fi
 
 if [ $word == 'Paraview' ]; then
 if [ $fast == 'no' ]; then 
 dialog --title "Done downloading" --msgbox " Paraview download not available" 10 50
 fi
#    echo 
 fi
 # Openmpi  3.1.3 ------------------------------------------------------------------------------------------
 if [ $word == 'openmpi' ]; then
 if [ $fast == 'no' ]; then 
 dialog --title "We are downloading fblaslapack" --msgbox "Now we are downloading openmpi: no other packages required " 10 50
 fi
   wget --progress=dot https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.3.tar.gz \
   2>&1 | grep "%" | sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e "s,\%,,g" \
   | dialog --gauge "Download openmpi" 10 100
    if [ $fast == 'no' ]; then 
   dialog --title "Done downloading" --msgbox "openmpi-3.1.3.tar.gz dowloaded from https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.3.tar.gz" 10 50
   fi
   mv openmpi-3.1.3.tar.gz packages_targz/openmpi-3.1.3.tar.gz
 fi
 # PETSC  3.10.2 ---------------------------------------------------------------------------------------------
 if [ $word == 'fblaslapack' ]; then
 
  if [ $fast == 'no' ]; then 
     dialog --title "Downloading fblaslapack" --msgbox "Now we are downloading fblaslapack: no other packages required " 10 50
     fi
     wget --progress=dot http://ftp.mcs.anl.gov/pub/petsc/externalpackages/fblaslapack-3.4.2.tar.gz \
     2>&1 | grep "%" |  sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e  "s,\%,,g" \
     | dialog --gauge "Download fblaslapack 3.4.2" 10 100
      if [ $fast == 'no' ]; then 
     dialog --title "Done downloading" --msgbox " fblaslapack-3.4.2 dowloaded from http://ftp.mcs.anl.gov/pub/petsc/externalpackages/fblaslapack-3.4.2.tar.gz" 10 50
      fi
      mv  fblaslapack-3.4.2.tar.gz     packages_targz/fblaslapack-3.4.2.tar.gz
     fi
 # PETSC  3.10.2 ---------------------------------------------------------------------------------------------
 if [ $word == 'petsc' ]; then
 
  if [ $fast == 'no' ]; then 
  dialog --title "Downloading PETSC" --msgbox "Now we are downloading PETSC 3.10.2: fblaslapack and openmpi required" 10 50 fblaslapack-3.4.2
  fi
     wget --progress=dot http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.10.2.tar.gz \
     2>&1 | grep "%" |  sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e  "s,\%,,g" \
     | dialog --gauge "Download petsc 3.10.2" 10 100
      if [ $fast == 'no' ]; then 
     dialog --title "Done downloading" --msgbox "petsc-3.10.2.tar.gz dowloaded from http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.10.2.tar.gz" 10 50
     fi
      mv  petsc-3.10.2.tar.gz    packages_targz/petsc-3.10.2.tar.gz
  fi
#  libmesh.sh 1.3.1 -----------------------------------------------------------------------------------------
 if [ $word == 'libmesh' ]; then
 
  if [ $fast == 'no' ]; then 
      dialog --title "Dowloading " --msgbox "Now we are downloading libmesh v1.3.1: openmpi and petsc required" 10 50
      fi
      wget --progress=dot https://github.com/libMesh/libmesh/releases/download/v1.3.1/libmesh-1.3.1.tar.gz \
       2>&1 | grep "%" |  sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e "s,\%,,g" \
      | dialog --gauge "Download libmesh v1.3.1" 10 100
     if [ $fast == 'no' ]; then 
     dialog --title "Done downloading" --msgbox "libmesh-1.3.1.tar.gz dowloaded: libmesh-1.3.1 from https://github.com/libMesh/libmesh/releases/download/v1.3.1/libmesh-1.3.1.tar.gz" 10 50
     fi
      mv   libmesh-1.3.1.tar.gz packages_targz/libmesh-1.3.1.tar.gz
 fi
 #  libmeshcpp.sh v0  ----------------------------------------------------------
 if [ $word == 'libmeshcpp' ]; then
 
  if [ $fast == 'no' ]; then 
      dialog --title "Dowloading " --msgbox "Now we are downloading libmeshcpp v0: libmesh + salome required" 10 50
      fi
       wget --progress=dot http://slipknot.ing.unibo.it/~test/libmeshcpp-v0.tar.gz \
   2>&1 | grep "%" | sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e "s,\%,,g" \
   | dialog --gauge "We are downloading FEMUs" 10 100
     if [ $fast == 'no' ]; then 
   dialog --title "Done downloading" --msgbox "femuscpp_v0.tar.gz dowloaded from http://slipknot.ing.unibo.it/~test/femuscpp_v0.tar.gz" 10 50
   fi
     mv libmeshcpp-v0.tar.gz   packages_targz/packages_targzlibmeshcpp-v0.tar.gz
 fi
 # femus ----------------------------------------------------------------------
 if [ $word == 'FEMUs' ]; then
  if [ $fast == 'no' ]; then 
  dialog --title "Downloading FEMUs" --msgbox "Now we are downloading FEMUs: SALOME, openmpi, petsc and libmesh required " 10 50
  fi
   wget --progress=dot http://slipknot.ing.unibo.it/~test/femus.tar.gz \
   2>&1 | grep "%" | sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e "s,\%,,g" \
   | dialog --gauge "We are downloading FEMUs" 10 100
   if [ $fast == 'no' ]; then 
   dialog --title "Done downloading" --msgbox "femus.tar.gz dowloaded from http://slipknot.ing.unibo.it/~test/femus.tar.gz" 10 50
   fi
   mv  femus.tar.gz  packages_targz/femus.tar.gz
 fi
 # DragonDonjon v5.0.2 ---------------------------------------------------------------------------------------
 if [ $word == 'DragonDonjon' ]; then
  if [ $fast == 'no' ]; then 
     dialog --title "Dowloading " --msgbox "Now we are downloading DragonDonjon:  no other packages required" 10 50
  fi
      wget --progress=dot http://www.polymtl.ca/merlin/downloads/version5_v5.0.2.tgz \
      2>&1 | grep "%" |  sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e "s,\%,,g" \
      | dialog --gauge "Download Dragon-Donjon v5.0.2" 10 100
       if [ $fast == 'no' ]; then 
      dialog --title "Done downloading" --msgbox "Dragon-Donjon v5.0.2 dowloaded from http://www.polymtl.ca/merlin" 10 50 
      fi 
    mv  version5_v5.0.2.tgz   packages_targz/version5_v5.0.2.tgz
 fi
 # ParaviewFoam ---------------------------------------------------------------
 if [ $word == 'ParaFOAM' ]; then
   if [ $fast == 'no' ]; then 
     dialog --title "Dowloading " --msgbox "Now we are downloading ParaFoam: no other packages  required" 10 50
   fi   
      wget --progress=dot https://sourceforge.net/projects/openfoamplus/files/ThirdParty-v3.0+.tgz \
      2>&1 | grep "%" |  sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e "s,\%,,g" \
      | dialog --gauge "Download Parafoam-ThirdParty v3.0+" 10 100
       if [ $fast == 'no' ]; then 
       dialog --title "Done downloading" --msgbox "ThirdParty-v3.0+ dowloaded: ThirdParty-v3.0+ from https://sourceforge.net/projects/openfoamplus/files/ThirdParty-v3.0+.tgz" 10 50 
       fi
       mv  ThirdParty-v3.0+.tgz     packages_targz/ThirdParty-v3.0+.tgz
 fi
 # Open foam OpenFOAM-v3.0+ ---------------------------------------------------
 if [ $word == 'OPENFOAM' ]; then
   if [ $fast == 'no' ]; then 
    dialog --title "Dowloading " --msgbox "Now we are downloading OpenFoam:  openmpi  required" 10 50
    fi
    wget --progress=dot https://sourceforge.net/projects/openfoamplus/files/OpenFOAM-v3.0+.tgz \
    2>&1 | grep "%" | sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e "s,\%,,g" \
    | dialog --gauge "Download Openfoam v3.0+" 10 100
   if [ $fast == 'no' ]; then 
   dialog --title "Done downloading" --msgbox "OPENFOAM-v3.0+ download from https://sourceforge.net/projects/openfoamplus/files/OpenFOAM-v3.0+.tgz" 10 50
   fi
  mv   OpenFOAM-v3.0+.tgz   packages_targz/OpenFOAM-v3.0+.tgz
 fi
  # Saturne  ---------------------------------------------------
 if [ $word == 'Saturne' ]; then
   if [ $fast == 'no' ]; then 
    dialog --title "Dowloading " --msgbox "Now we are downloading Saturne: see README for packages  required" 10 50
    fi
    wget --progress=dot http://code-saturne.org/cms/sites/default/files/releases/code_saturne-4.0.5.tar.gz \
    2>&1 | grep "%" | sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e "s,\%,,g" \
    | dialog --gauge "Download Saturne 4.0.5  " 10 100
      if [ $fast == 'no' ]; then 
    if [ $fast == 'no' ]; then 
   dialog --title "Done downloading" --msgbox "saturne-4.0.5  download from http://code-saturne.org/cms/sites/default/files/releases/code_saturne-4.0.5.tar.gz" 10 50
   fi
    fi 
 mv      code_saturne-4.0.5.tar.gz  packages_targz/code_saturne-4.0.5.tar.gz
 fi
 
      
done
# msg_dialog = " \n CATHARE: download not available "
dialog --title "Done downloading" --msgbox "You have dowloaded the following packages: $choiced   " 10 50
	
}
