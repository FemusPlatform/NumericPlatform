 
# #############################################################################
# Install Dragon Donjon
#
# call this script as
# source Dragon Dopnjon.sh v5.0
#        dragondonjon.sh package-version 
# #############################################################################
PKG_NAME=dragondonjon-V5.0.5
PKG_DIR=$PKG_NAME;
TAR_DIR=packages_targz;
LOG_DIR=package_logs
SCRIPT_NAME=dragondonjon

# #############################################################################
echo 
echo " --------- Start dragondonjon.sh script -------- "
echo
echo $SCRIPT_NAME ": Script set up for "  $SCRIPT_NAME 
echo
cd ..
if [ -f "platform_conf.sh" ]; then
  source platform_conf.sh
  
# 1c --------------- platform setup -------------------------------------------
 INSTALL_TAR_DIR=$BUILD_DIR/$TAR_DIR/
 INSTALL_PLAT_LOG_DIR=$BUILD_DIR/$LOG_DIR
 TARFILE=$INSTALL_TAR_DIR/Version5.0.5.tgz
 
 INSTALL_PLAT_PKG_DIR=$PLAT_CODES_DIR/$PKG_NAME
#------------------------------------------------------------------------------
 echo Code $SCRIPT_NAME 
 echo $SCRIPT_NAME ": 1c BUILD dir (BUILD_DIR) is                       " = $BUILD_DIR
 echo $SCRIPT_NAME ": 1c INSTALLATION platform DIR for CODES is         " = $PLAT_CODES_DIR
 
 echo $SCRIPT_NAME ": 1c INSTALL_PLAT_LOG_DIR  (log dir)                " = $INSTALL_PLAT_LOG_DIR
 echo $SCRIPT_NAME ": 1c INSTALL_PLAT_PKG_DIR  (application dir)        " = $INSTALL_PLAT_PKG_DIR
 echo $SCRIPT_NAME ": 1c TAR_DIR (package archive dir)                  " = $INSTALL_TAR_DIR

# # 1) ==================  setup ================================================

# 1c up to BUILD dir ----------------------------------------------------------
echo
echo
echo $SCRIPT_NAME ": 1 set up: "
cd $BUILD_DIR


if [ ! -d "$INSTALL_PLAT_PKG_DIR" ]; then
  echo  "mkdir $INSTALL_PLAT_PKG_DIR"
  mkdir $INSTALL_PLAT_PKG_DIR
  
  if [ ! -f $INSTALL_TAR_DIR/version5_v5.0.5.tgz ]; then
        wget --progress=dot http://www.polymtl.ca/merlin/downloads/version5_v5.0.5.tgz \
      2>&1 | grep "%" |  sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e "s,\%,,g" \
      | dialog --gauge "Download Dragon-Donjon v5.0.5" 10 100
        clear
        if [ $fast == 'no' ]; then 
          dialog --title "Done downloading" --msgbox "Dragon-Donjon v5.0.2 dowloaded from http://www.polymtl.ca/merlin" 10 50 
          clear
        fi
          mv  version5_v5.0.5.tgz    $INSTALL_TAR_DIR/version5_v5.0.5.tgz
      fi
  
  echo "Dragon Donjon does not exist: extraction tar"
  tar -xzf $INSTALL_TAR_DIR/Version5_v5.0.5.tgz -C $INSTALL_PLAT_PKG_DIR --strip-components 1
    
  echo $SCRIPT_NAME ": 1c  Dragon Donjon extract and in place" 
else
  echo " Dragon Donjon dir exists: no extraction tar"
fi
echo

# 2) Install OpenMPI script  ==================================================
# openfoam is buid in its own directory
cd $INSTALL_PLAT_PKG_DIR    
echo $SCRIPT_NAME " 2a: build in " $PWD

# ..................................................................
#!/bin/bash 
# ..................................................................=
echo ".................................................................."
echo "STARTING UTILIB in $PWD"
cd ./Utilib/
../script/install  > $INSTALL_PLAT_LOG_DIR/utilib
 grep "Install  : ERROR" $INSTALL_PLAT_LOG_DIR/utilib
 if [  "$?" -eq "0" ]; then
 echo -e "${red}ERROR! Finalizing UTILIB installation see" $INSTALL_PLAT_LOG_DIR/utilib
cd ..
#exit 1
fi
kill $!; trap 'kill $!' SIGTERM
echo "\n"
echo "DONE UTILIB"
echo ".................................................................."

echo "STARTING GANLIB"
cd ../Ganlib/
../script/install > $INSTALL_PLAT_LOG_DIR/ganlib
grep "Install  : ERROR" $INSTALL_PLAT_LOG_DIR/ganlib
if [  "$?" -eq "0" ]; then
echo -e "${red}ERROR! Finalizing UTILIB installation see " $INSTALL_PLAT_LOG_DIR/ganlib
cd ..
#exit 1
fi
echo "DONE GANLIB"
echo ".................................................................."
echo "STARTING TRIVAC"
cd ../Trivac/
../script/install > $INSTALL_PLAT_LOG_DIR/trivac
grep "Install  : ERROR" $INSTALL_PLAT_LOG_DIR/trivac
if [  "$?" -eq "0" ]; then
echo -e "${red}ERROR! Finalizing UTILIB installation see " $INSTALL_PLAT_LOG_DIR/trivac
cd ..
#exit 1
fi
echo "DONE TRIVAC"
echo ".................................................................."
echo "STARTING DRAGON"
cd ../Dragon/
../script/install > $INSTALL_PLAT_LOG_DIR/dragon
grep "Install  : ERROR" $INSTALL_PLAT_LOG_DIR/dragon
if [  "$?" -eq "0" ]; then
echo -e "${red}ERROR! Finalizing DRAGON installation see " $INSTALL_PLAT_LOG_DIR/dragon
cd ..
#exit 1
fi
echo "DONE DRAGON"
echo ".................................................................."
echo "STARTING DONJON"
cd ../Donjon/
../script/install> $INSTALL_PLAT_LOG_DIR/donjon
grep "Install  : ERROR" $INSTALL_PLAT_LOG_DIR/donjon
if [  "$?" -eq "0" ]; then
echo -e "${red}ERROR! Finalizing DONJON installation see " $INSTALL_PLAT_LOG_DIR/donjon
cd ..
#exit 1
fi
echo "DONE DONJON"

echo ".................................................................."
echo "STARTING SKINN++"
export BOOST_ROOT=/usr/
cd ../Skin++/
../script/install> $INSTALL_PLAT_LOG_DIR/skinn
grep "Install  : ERROR" $INSTALL_PLAT_LOG_DIR/skinn
if [  "$?" -eq "0" ]; then
echo -e "${red}ERROR! Finalizing SKINN++ installation see " $INSTALL_PLAT_LOG_DIR/skinn

#object files in c++
cd src
make
cd ..
fi
echo "DONE SKINN++"
cd ..
echo ".................................................................."
cd ..

echo ".................................................................."
echo "DONE"
echo ".................................................................."

ln -s $INSTALL_PLAT_PKG_DIR  $PLAT_CODES_DIR/$SCRIPT_NAME;

cd $PLAT_CODES_DIR/$SCRIPT_NAME/Skin++/
make

# MOVE DUPLICATE FILES
mv $PLAT_CODES_DIR/$SCRIPT_NAME//Trivac/src/TRIVAC.o $PLAT_CODES_DIR/$SCRIPT_NAME//Trivac/src/TRIVAC.old
mv $PLAT_CODES_DIR/$SCRIPT_NAME//Dragon/src/DRAGON.o $PLAT_CODES_DIR/$SCRIPT_NAME//Dragon/src/DRAGON.old
mv $PLAT_CODES_DIR/$SCRIPT_NAME//Ganlib/src/GANMAIN.o $PLAT_CODES_DIR/$SCRIPT_NAME//Ganlib/src/GANMAIN.old
mv $PLAT_CODES_DIR/$SCRIPT_NAME//Donjon/src/DONJON.o $PLAT_CODES_DIR/$SCRIPT_NAME//Donjon/src/DONJON.old
mv $PLAT_CODES_DIR/$SCRIPT_NAME//Ganlib/src/xabort_c.o $PLAT_CODES_DIR/$SCRIPT_NAME//Ganlib/src/xabort_c.old
mv $PLAT_CODES_DIR/$SCRIPT_NAME//Skin++/src/Skin++.o $PLAT_CODES_DIR/$SCRIPT_NAME//Skin++/src/Skin++.old

else
  
  echo  " Wrong directory or enviromnent !!!!! look for plat_conf.sh generated by plaftorm.sh !!!!!!"

fi

echo " IMPORTANT "
echo ".................................................................."
echo " CHANGE #define max and #define min into #define mymax and #define mymin "
echo " INSIDE Ganlib/src/cle2000.h FILE "
echo ".................................................................."


cd $BUILD_DIR
