# ==========================================================================================================================
function run_dowloading_local(){
# get $1  from table  PLAT_BUILD/buildgui_vers.sh
# ==========================================================================================================================
 #  file *.tar.gz ($package_targz) or from local ($local_repo_targz)---------------------------------------------------------
  package_name=$1
  machine_repo="femus_repo@137.204.240.19:/home/femus_repo/"
  local_repo_targz=$PWD"/packages_targz/"
  path_file_name=$local_repo_targz$package_name
  
if [ -f $path_file_name ]; then
    dialog --title "Local downloading (ok option)" --msgbox "The package $package_name is already here locally in $local_repo_targz (be happy!) " 10 50
else
    dialog --title "Local downloading (ok option)" --msgbox " Searching  .... package $package_name  is not in $local_repo_targz ... now trying from $machine_repo" 10 50 
    scp $machine_repo$package_name   $path_file_name
        # check download ---------------------------------------------------------
    if [ -f $path_file_name ]; then
        dialog --title "Local downloading (ok option)" --msgbox "$package_name dowloaded from local server $machine_repo (only in unibo)" 10 50
    else
        dialog --title "Local downloading (ok option) " --msgbox "Dowloading  $package_name  failed: local server not available (only in unibo)!! 
        Please use web_site option in the previous menu or copy  your src_tar-package in targz directory in $local_repo_targz " 10 50
    fi
         # end check download ------------------------------------------------------
 fi  
}

# ==========================================================================================================================
function run_dowloading_web(){
# get $1 $2 from table  PLAT_BUILD/buildgui_vers.sh
# ==========================================================================================================================
  package_name=$1
  url=$2
  local_repo_targz=$PWD"/packages_targz/"
  path_file_name=$local_repo_targz$package_name

 #  file *.tar.gz ($package_targz) from  website ($local_repo_targz)---------------------------------------------------------
if [ -f $path_file_name ]; then
    dialog --title "Web download (web_site option)" --msgbox "The package $package_name is already here locally in $local_repo_targz" 10 50
else
    dialog --title "Web downloading (web_site option)" --msgbox "Now we are downloading $package_name: no other packages required " 10 50 
    wget --progress=dot -O $package_name $url \
    2>&1 | grep "%" | sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e "s,\%,,g" \
    | dialog --gauge "We are downloading $package_name" 10 100
     #  check download -----------------------------------------------------------------
    if [ -f $package_name ]; then
         dialog --title "Web download (web_site option)" --msgbox "$package_name dowloaded from $url" 10 50
         mv $package_name  $path_file_name
    else
         dialog --title "Web download (web_site option)" --msgbox "Dowloading from $url option failed: web site incorrect or version incorrect" 10 50
    fi
         # end check download ------------------------------------------------------------
 fi
}


# ==========================================================================================================================
function show_dowloading(){
# ==========================================================================================================================
	
: ${DIALOG=dialog}
: ${DIALOG_OK=0}
: ${DIALOG_CANCEL=1}
: ${DIALOG_EXTRA=3}
: ${DIALOG_ESC=255}
tempfiled=`tempfiled 2>/dev/null` || tempfiled=/tmp/test$$
trap "rm -f $tempfiled" 0 1 2 5 15

$DIALOG --backtitle "Software platform download" \
        --extra-button --extra-label "web_site" \
        --title "Download packages" \
        --checklist "
Press SPACE to toggle an option on/off. \n\n\
  Check on the package to Dowload" 23 50 13 \
        "med"              "$med_ver"           off \
        "medcoupling"      "$medcoupling_ver"   off \
        "salome"           "$salome_ver"        off \
        "openmpi"          "$openmpi_ver"       off \
        "fblaslapack"      "$fblaslapack_ver"   off \
        "petsc"            "$petsc_ver"         off \
        "libmesh"          "$libmesh_ver"       off \
        "femus"            "$femus_ver"         off \
        "libmeshcpp"       "$libmeshcpp_ver"    off \
        "paraview"         "$paraview_ver"      off \
        "dragondonjon"     "$dragondonjon_ver"  off \
        "parafoam"         "$parafoam_ver"      off \
        "openfoam"         "$openfoam_ver"      off \
        "saturne"          "$saturne_ver"       off 2> $tempfiled

retvald=$?
#choiced=`cat $tempfiled`
choiced=` sed s/\"//g  $tempfiled`
choiced2=` sed s/\"//3g  $tempfiled`

more  $tempfiled
web_site=no
case $retvald in
    $DIALOG_OK)
     echo "'$choiced' chosen.";;
    $DIALOG_EXTRA)
     web_site=yes;;
    $DIALOG_CANCEL)
     echo "Cancel pressed.";;
    $DIALOG_ESC)
     echo "ESC pressed.";;
   *)
    echo "Unexpected return code: $retvald (ok would be $DIALOG_OK)";;
esac 


msg_dialog=""

for word in $choiced; do 

 eval name_pck='$'"$word"_name_download
# pck=$word"_pck" 
# evaname_pck=$word"_name_pck"
 eval url='$'"$word"_url
 
# if [ $word == 'salome' ]; then
  dialog --title "Downloading $name_pck" --msgbox "Now we are downloading  $name_pck " 10 50
if [ $web_site == 'no' ]; then 
    run_dowloading_local   $name_pck #   from  local PLAT_BUILD/packages_targz
else
    run_dowloading_web $name_pck $url  #  file  from  webside
fi


# # ========================================================================================================================== 
done
# msg_dialog = " \n CATHARE: download not available "
	
}
