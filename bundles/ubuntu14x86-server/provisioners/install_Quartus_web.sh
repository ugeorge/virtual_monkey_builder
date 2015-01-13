#!/bin/bash

###begin documentation##########################################################
#
# Author:  George Ungureanu <ugeorge@kth.se>
# Date:    2014.12.19
# Purpose: Quartus 13.0sp1 Web (Free) edition.
# Comment: The Altera download links are quite resilient, so no worries there.
#          On the other hand, if that fails, go to http://dl.altera.com/?edition=web
#          select version 13.0sp1 and download the combined package. You need
#          to have a valid account on the Altera site, so you might have to 
#          subscribe to them...

#Dfml Quartus-web-13.0.1.232-linux.tar 7588ed734761f62ec8f86b07a5adfffd http://download.altera.com/akdlm/software/acdsinst/13.0sp1/232/ib_tar/Quartus-web-13.0.1.232-linux.tar
#
###end documentation############################################################

sudo apt-get install -y gcc-multilib g++-multilib expat:i386 fontconfig:i386 libfreetype6:i386 libexpat1:i386 libc6:i386 libgtk-3-0:i386 libcanberra0:i386 libpng12-0:i386 libice6:i386 libsm6:i386 libncurses5:i386 zlib1g:i386 libx11-6:i386 libxau6:i386 libxdmcp6:i386 libxext6:i386 libxft2:i386 libxrender1:i386 libxt6:i386 libxtst6:i386

echo "Copying Quartus installer..."
mkdir /tmp/qinstall
tar -xvf /tmp/Quartus-web-13.0.1.232-linux.tar -C  /tmp/qinstall
rm /tmp/Quartus-web-13.0.1.232-linux.tar

echo "Installing Quartus tools in /opt/altera/13.0sp1..."
echo "Sit back, relax, grab a milkshake, watch a movie... seriously, it will take ages!"
sudo rm /tmp/qinstall/components/arria_web-13.0.1.232.qdz
cd /tmp/qinstall
sudo ./components/QuartusSetupWeb-13.0.1.232.run --mode unattended --unattendedmodeui none --installdir /opt/altera/13.0sp1
echo "Uninstalling the nasty subscription edition of Modelsim..."
sudo chmod +x /opt/altera/13.0sp1/uninstall/modelsim_ae-13.0.1.232-uninstall.run
cd /opt/altera/13.0sp1
sudo ./uninstall/modelsim_ae-13.0.1.232-uninstall.run --mode unattended
rm -rf /tmp/qinstall

mkdir -p ~/Desktop
touch ~/Desktop/Nios2_Shell.desktop
echo '[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Icon[en_US]=gnome-ccperiph
Name[en_US]=NIOS 2 Shell
Exec=lxterminal  --command "/home/student/n2sdk"
Comment[en_US]=Launches a pre-configured shell environment for NIOS 2
Name=NIOS 2 Shell
Comment=Launches a pre-configured shell environment for NIOS 2
Icon=ibus-engine
StartupNotify=true' > ~/Desktop/Nios2_Shell.desktop

touch ~/n2sdk
echo '#!/bin/bash
# Run this for a Nios II SDK bash shell
export LM_LICENSE_FILE=@lic1.ict.kth.se
SOPC_KIT_NIOS2=/opt/altera/13.0sp1/nios2eds
export SOPC_KIT_NIOS2
SOPC_BUILDER_PATH_130=/opt/altera/13.0sp1/nios2eds
export SOPC_BUILDER_PATH_130
unset GCC_EXEC_PREFIX
QUARTUS_ROOTDIR=/opt/altera/13.0sp1/quartus
export QUARTUS_ROOTDIR
export PERL5LIB=/usr/lib/perl/5.18.2
cd /home/student/Desktop/
bash --rcfile $SOPC_BUILDER_PATH_130/nios2_command_shell.sh' > ~/n2sdk

