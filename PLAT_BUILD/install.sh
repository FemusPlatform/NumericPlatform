#!/bin/bash
# =======================================================================================
#               Package download function
# =======================================================================================
source gui_dowload.sh # contains show_dowloading
# =======================================================================================
#               Package guide function
# =======================================================================================
source gui_guide.sh # contains show_guide
# =======================================================================================
#               Package installation function
# =======================================================================================
source gui_install_package.sh # contains show_install
# ===================================================================================

export REQUIREMENTS_SATISFIED=0
source install_scripts/requirements.sh

echo "Check requirements completed "
if [ $REQUIREMENTS_SATISFIED == '1' ]; then
   echo "Requirements not satisfied"
   echo "Please install missing packages to continue installation"
   return;
fi
read -p "Press enter to continue installation"

if [ -f '../plat_conf.sh' ]; then
  source ../plat_conf.sh
else
  echo "Shell script PLAT_BUILD/plat_conf.sh not found "
  echo "Please run SeUpPlatform "
fi  
  
  
# Store menu options selected by the user
INPUT=/tmp/menu.sh.$$
# Storage file for displaying cal and date command output
OUTPUT=/tmp/output.sh.$$
# get text editor or fall back to vi_editor
vi_editor=${EDITOR-vi}
# trap and delete temp files
trap "rm $OUTPUT; rm $INPUT; exit" SIGHUP SIGINT SIGTERM

# 
# set infinite loop
#
while true
do

### display main menu ###
dialog --clear  --backtitle " Platform installer " \
  --title "[ INSTALLATION MENU ]" \
  --menu "Choose the TASK" 25 70 10 \
Download       "Dowload packages" \
SetUpPlatform  "Set up Numerical Platform structure" \
InstThirdParty "Install Third Party Packages" \
InstCodes      "Install Numerical Codes" \
Guide          "Installation guide " \
Editor         "Start a text editor" \
Exit           "Exit to the shell" 2>"${INPUT}"

menuitem=$(<"${INPUT}")
# make decsion 
case $menuitem in
	Download) show_dowloading;;
	SetUpPlatform) show_platform;;
    InstThirdParty) show_third_packages;;
    InstCodes) show_codes;;
	Guide) show_guide;;
	Editor) $vi_editor;;
	Exit) echo "Bye"; clear; break;;
esac

done

# if temp files found, delete em
[ -f $OUTPUT ] && rm $OUTPUT
[ -f $INPUT ] && rm $INPUT
