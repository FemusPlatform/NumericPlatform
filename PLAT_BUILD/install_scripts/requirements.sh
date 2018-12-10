# utility functions -----------------------------------------------------------
red=`tput setaf 1`; bold=`tput bold `; green=`tput setaf 2`; reset=`tput sgr0`

function check_presence { 

  echo "---------------------------------------"
  echo "Check $1 "
  if [ $(command -v $1) == "" ]; then
    echo "${red}$1 not present, install $1 ${NC}"
  else
    echo "${green}$1 present ${NC}"
  fi
  
}

echo "Check linux distribution " 
export distro=$(lsb_release -i)
export DISTRO=${distro:16}

check_presence dialog
check_presence gcc
