#!/bin/bash

###begin documentation##########################################################
#
# Author:  George Ungureanu <ugeorge@kth.se>
# Date:    2014.12.19
# Purpose: Installs GNU Ada 2012 + STLink toolchain
# Comment: The installation package must be acquired manually from 
#          http://libre.adacore.com/download/ and follow the steps:
#          * select " Free Software or Academic Development " and proceed
#          * select platform " x86 GNU Linux (32 bits)" and " GNAT GPL 2012 "
#          * select GNAT Ada GPL 2012 and tick 'gnat-gpl-2012-i686-gnu-linux-libc2.3-bin.tar.gz'
#          * select bunde format and click to download
#          * unpack the downloaded archive. Check the contents
#          * move file 'gnat-gpl-2012-i686-gnu-linux-libc2.3-bin.tar.gz' to the project's
#            'packages' folder

# [Dependency strings]
#Dfm gnat-gpl-2012-i686-gnu-linux-libc2.3-bin.tar.gz f68bb96b7e265b1182b10a37ac1838a2
#
###end documentation############################################################
  
sudo apt-get install -y libsgutils2-dev
sudo apt-get install -y libusb-1.0-0-dev
sudo apt-get install -y lib32ncurses5
# if necessary...
sudo apt-get install -y autoconf
sudo apt-get install -y automake
sudo apt-get install -y libtool
sudo apt-get install -y git-core
# ... end if necessary

mkdir /tmp/adainstall
tar -xf /tmp/gnat-gpl-2012-i686-gnu-linux-libc2.3-bin.tar.gz -C /tmp/adainstall
rm /tmp/gnat-gpl-2012-i686-gnu-linux-libc2.3-bin.tar.gz

cd /tmp/adainstall/gnat-2012-i686-gnu-linux-libc2.3-bin
sudo make ins-all prefix=/usr/gnat

cd /tmp/
sudo echo "export PATH=/usr/gnat/bin:$PATH" >> ~/.bashrc
rm -rf /tmp/adainstall

git clone https://github.com/texane/stlink stlink.git

cd stlink.git

./autogen.sh
./configure
make

# Copy the udev rules to /etc/udev/rules.d/
sudo cp 49-stlinkv* /etc/udev/rules.d/.
#sudo cp st-* /usr/local/stlink/bin

# restart the udev service.
sudo udevadm control --reload-rules







