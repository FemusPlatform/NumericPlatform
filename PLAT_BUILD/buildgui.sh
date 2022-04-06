#!/bin/bash
# =======================================================================================
#               Package download function
# =======================================================================================
source buildgui_dowload.sh # contains show_dowloading
# =======================================================================================
#               Package guide function
# =======================================================================================
source buildgui_guide.sh # contains show_guide
# =======================================================================================
#               Package installation function
# =======================================================================================
source buildgui_package.sh # contains show_install
# ===================================================================================

source buildgui_vers.sh

echo "Check requirements completed "
if [ $REQUIREMENTS_SATISFIED == '1' ]; then
   echo "Requirements not satisfied"
   echo "Please install missing packages to continue installation"
   return;
fi
read -p "Press enter to continue installation"

# check for platform_conf.sh in the directory above
if [ -f '../platform_conf.sh' ]; then
  source ../platform_conf.sh
else
  echo "Shell script PLAT_BUILD/plat_conf.sh not found "
  echo "Please run platform_init.sh or platform2_set.sh in the above directory typing the command: "
  echo "source platform2_set.sh"
  return;
fi  
  
  
# Store menu options selected by the user
INPUT=/tmp/menu.sh.$$
# Storage file for displaying cal and date command output
OUTPUT=/tmp/output.sh.$$
# get text editor or fall back to vi_editor
vi_editor=${EDITOR-vi}
vi_editor="kate"
# trap and delete temp files
trap "rm $OUTPUT; rm $INPUT; exit" SIGHUP SIGINT SIGTERM

# 
# set infinite loop
#
while true
do

### display main menu ###
dialog  --backtitle " Platform installer " \
  --title "[ INSTALLATION MENU ]" \
  --menu "Choose the TASK" 25 70 10 \
InstThirdParty "Install Third Party Packages" \
InstCodes      "Install Numerical Codes" \
Download       "Dowload packages (in PLAT_BUILD/packages_targz) " \
CodeVersions    "Changing platfrom code versions" \
Guide          "Installation guide " \
Editor         "Start a text editor" \
Exit           "Exit to the shell" 2>"${INPUT}"

menuitem=$(<"${INPUT}")
# make decsion 
case $menuitem in
	
        InstThirdParty) show_third_packages;;
        InstCodes)      show_codes;;
        Download)       show_dowloading;;
        CodeVersions)   $vi_editor buildgui_vers.sh;;
	Guide)          show_guide;;
	Editor)         $vi_editor;;
	Exit)           echo "Bye";  break;;
esac

done

# if temp files found, delete em
[ -f $OUTPUT ] && rm $OUTPUT
[ -f $INPUT ] && rm $INPUT
