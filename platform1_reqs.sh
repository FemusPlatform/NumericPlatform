red=`tput setaf 1`; bold=`tput bold `; green=`tput setaf 2`; reset=`tput sgr0`; NC=`tput sgr0`

function  command_exists () {
    type "$1" &> /dev/null ;
}

function check_executable () { 
  if command_exists $1 ; then
    echo "Check $1: ${green}$1 present ${NC}" 
    echo "Check $1: $1 present " >> platform_requirements.log
  else
    echo "Check $1: ${red}$1 missing ${NC}"
    echo "Check $1: $1 missing " >> platform_requirements.log
    REQUIREMENTS_SATISFIED=1
  fi
}


if [ -f "plat_requirements.log" ]; then
  rm ./plat_scripts/platform_requirements.log
  echo deleted ./plat_scripts/platform_requirements.log
fi  

echo "Check linux distribution " 
echo "Check linux distribution " >> platform_requirements.log
cat /etc/*-release
cat /etc/*-release >> platform_requirements.log

check_executable dialog
check_executable gcc
check_executable g++
check_executable kate


echo
