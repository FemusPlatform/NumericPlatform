red=`tput setaf 1`; bold=`tput bold `; green=`tput setaf 2`; reset=`tput sgr0`; NC=`tput sgr0`

function  command_exists () {
    type "$1" &> /dev/null ;
}

function check_executable () { 
  if command_exists $1 ; then
    echo "Check $1: ${green}$1 present ${NC}" 
    echo "Check $1: $1 present " >> requirements.log
  else
    echo "Check $1: ${red}$1 missing ${NC}"
    echo "Check $1: $1 missing " >> requirements.log
    REQUIREMENTS_SATISFIED=1
  fi
}

if [ -f "requirements.log" ]; then
  rm requirements.log
fi  

echo "Check linux distribution " 
echo "Check linux distribution " >> requirements.log
export distro=$(lsb_release -i)
export DISTRO=${distro:16}

echo "Current linux distribution is: $DISTRO"
echo "Current linux distribution is: $DISTRO" >> requirements.log

check_executable dialog
check_executable gcc
check_executable g++


echo
