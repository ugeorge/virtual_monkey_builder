
--------------------------------------------------------------------------------

                    Virtual Monkey Builder (VMB-0.1.1)
                       - generated documentation -

--------------------------------------------------------------------------------

Base folder: /home/iedu/Work/virtual_monkey_builder

Please check README.md for general usage and command-line options.

1.Available bundles
===================

I have found the following bundles:
  * ubuntu14x86-server
    ├─ base OS iso : /home/iedu/Work/virtual_monkey_builder/bundles/ubuntu14x86-server/bases/ubuntu-14.04.1-server-i386.iso
    ├─ and provisioners:
       ├─ install_Quartus_subscription.sh
       ├─ wrap-up.sh
       ├─ init.sh
       ├─ install_forsyde_haskell.sh
       ├─ fix_modelsim_dependencies.sh
       ├─ install_university_program.sh
       ├─ install_forsyde.sh
       ├─ install_Quartus_web.sh
       ├─ fix_blaster_drivers.sh
       ├─ install_forsyde_systemc.sh
       ├─ install_ada_stlink.sh
       ├─ provisioner.template
       ├─ install_vbox_guest_additions.sh


2.Documentation for available provisioners
==========================================

The provisioners can be seen in section '1.Available bundles'. They are scripts 
which are run initially inside the VM to install different software components.
The following paragraphs show their documentation as it is provided:

/home/iedu/Work/virtual_monkey_builder/bundles/ubuntu14x86-server/provisioners/install_Quartus_subscription.sh
--------------------------------------


 Author:  George Ungureanu <ugeorge@kth.se>
 Date:    2014.12.19
 Purpose: Quartus 13.0sp1 Subscription edition.
 Comment: The Altera download links are quite resilient, so no worries there.
          On the other hand, if that fails, go to 
          https://www.altera.com/download/software/quartus-ii-se
          select version 13.0sp1 and download the combined package. You need
          to have a valid account on the Altera site, so you might have to 
          subscribe to them...

Dfml Quartus-13.0.1.232-linux.tar a809dd618670bab8b0bfb7f1a6f3d4dd http://download.altera.com/akdlm/software/acdsinst/13.0sp1/232/ib_tar/Quartus-13.0.1.232-linux.tar
Dfml Quartus-13.0.1.232-devices-1.tar fac11159c3d8a202d3f84a17ec4f95d3 http://download.altera.com/akdlm/software/acdsinst/13.0sp1/232/ib_tar/Quartus-13.0.1.232-devices-1.tar


/home/iedu/Work/virtual_monkey_builder/bundles/ubuntu14x86-server/provisioners/init.sh
--------------------------------------


 Author:  George Ungureanu <ugeorge@kth.se>
 Date:    2014.12.19
 Purpose: The first commands that should be run during the first login.
 Comment: 


/home/iedu/Work/virtual_monkey_builder/bundles/ubuntu14x86-server/provisioners/install_forsyde_haskell.sh
--------------------------------------


 Author:  George Ungureanu <ugeorge@kth.se>
 Date:    2015.01.08
 Purpose: ForSyDe-Haskell EDSL
 Comment: 


/home/iedu/Work/virtual_monkey_builder/bundles/ubuntu14x86-server/provisioners/fix_modelsim_dependencies.sh
--------------------------------------


 Author:  George Ungureanu <ugeorge@kth.se>
 Date:    2014.12.19
 Purpose: Modelsim depends on a font which is no longer available in Ubuntu 14.
          This script takes care of building it and providing it as a library.
 Comment: I do not know how long that link will work. It tries to download the 
          package prior to the build process. In case it fails please contact me
          to send it to you directly.

Dfml freetype-2.4.12.tar.bz2 3463102764315eb86c0d3c2e1f3ffb7d http://nongnu.uib.no//freetype/freetype-2.4.12.tar.bz2 


/home/iedu/Work/virtual_monkey_builder/bundles/ubuntu14x86-server/provisioners/install_university_program.sh
--------------------------------------


 Author:  George Ungureanu <ugeorge@kth.se>
 Date:    2014.12.19
 Purpose: This script downloads and installs the Altera University Program
 Comment: In the unlikely case that the link is broken, you have to acquire the
          package manually from http://www.altera.com/education/univ/software/upds/unv-upds.html
           * place the archive inside the Monkey's 'packages' folder. 
           * invalidate the 'Dl' command, by adding some spaces after 
           * validate the 'Dfml' command
           * comment out the 'wget...' line of code
          Otherwise, if it still does not work, contact me.

     Dfml altera_upds_setup.tar 64d65e4843b88320d1ac1700a43bb8d2 ftp://ftp.altera.com/up/pub/Altera_Material/13.0/altera_upds_setup.tar
Dl ftp://ftp.altera.com/up/pub/Altera_Material/13.0/altera_upds_setup.tar


/home/iedu/Work/virtual_monkey_builder/bundles/ubuntu14x86-server/provisioners/install_Quartus_web.sh
--------------------------------------


 Author:  George Ungureanu <ugeorge@kth.se>
 Date:    2014.12.19
 Purpose: Quartus 13.0sp1 Web (Free) edition.
 Comment: The Altera download links are quite resilient, so no worries there.
          On the other hand, if that fails, go to http://dl.altera.com/?edition=web
          select version 13.0sp1 and download the combined package. You need
          to have a valid account on the Altera site, so you might have to 
          subscribe to them...

Dfml Quartus-web-13.0.1.232-linux.tar 7588ed734761f62ec8f86b07a5adfffd http://download.altera.com/akdlm/software/acdsinst/13.0sp1/232/ib_tar/Quartus-web-13.0.1.232-linux.tar


/home/iedu/Work/virtual_monkey_builder/bundles/ubuntu14x86-server/provisioners/fix_blaster_drivers.sh
--------------------------------------


 Author:  George Ungureanu <ugeorge@kth.se>
 Date:    2014.12.19
 Purpose: fix the correct USB Blaster device driver rules


/home/iedu/Work/virtual_monkey_builder/bundles/ubuntu14x86-server/provisioners/install_forsyde_systemc.sh
--------------------------------------


 Author:  George Ungureanu <ugeorge@kth.se>
 Date:    2014.12.19
 Purpose: ForSyDe-SystemC library and environment
 Comment: I don't know if the Accelera link works for everybody. In case the
          configuration fails, get SystemC 2.3.0 from the Accelera Initiative download page:
          http://www.accellera.org/downloads/standards/systemc
          register, and download systemc-2.3.0.tgz

Dfml systemc-2.3.0.tgz c26b9116f29f1384e21ab8abdb2dd70f www.accellera.org/downloads/standards/systemc/accept_license/accepted_download/systemc-2.3.0.tgz


/home/iedu/Work/virtual_monkey_builder/bundles/ubuntu14x86-server/provisioners/install_ada_stlink.sh
--------------------------------------


 Author:  George Ungureanu <ugeorge@kth.se>
 Date:    2014.12.19
 Purpose: Installs GNU Ada 2012 + STLink toolchain
 Comment: The installation package must be acquired manually from 
          http://libre.adacore.com/download/ and follow the steps:
          * select " Free Software or Academic Development " and proceed
          * select platform " x86 GNU Linux (32 bits)" and " GNAT GPL 2012 "
          * select GNAT Ada GPL 2012 and tick 'gnat-gpl-2012-i686-gnu-linux-libc2.3-bin.tar.gz'
          * select bunde format and click to download
          * unpack the downloaded archive. Check the contents
          * move file 'gnat-gpl-2012-i686-gnu-linux-libc2.3-bin.tar.gz' to the project's
            'packages' folder

 [Dependency strings]
Dfm gnat-gpl-2012-i686-gnu-linux-libc2.3-bin.tar.gz f68bb96b7e265b1182b10a37ac1838a2


/home/iedu/Work/virtual_monkey_builder/bundles/ubuntu14x86-server/provisioners/provisioner.template
--------------------------------------


 This is a template showing the structure of a provisioner script. It consists 
 in three sections: preamble, dependency commands, and the actual script code.
 When you make a new bundle, copy this file into the following path:
    ${VMB_PATH}/bundles/${YOUR_BUNDLE}/provisioners
 and start modifying it to fit your purpose (ideally removing the comments).

 [Preamble]
 Author  : you
 Date    : today
 Purpose : short descrition of what this script does.
 Comment : additional comments and instructions how to acquire the packages

 [Dependencies]
 Here you write the commands describing the packages or files which your 
 provisioner script relies upon. Remember that this whole source will be moved
 inside the guest machine and be executed, thus the dependency commands should
 actually look like comments (start with a  character). They wil be taken care 
 of separately by the Monkey. 

 The dependency strings have the following format:
command [arguments...]
 where <command> defines what arguments are expected. The following strings are 
 accepted (assuming they start at the beginning of a new line):
   Df <file_name>                        
      just a file name (not recommended) 
   Dfm <file_name> <md5_checksum>        
      file name and checksum to verify if it is the correct one
   Dl <url>                              
      just a link. It assumes that the provisioner will download something 
      inside the guest, and the Monkey just has to verify if the link is active
   Dfl <file_name> <url>
      The file will be downloaded during the configuration phase and copied 
      inside the guest OS where will be used by the provisioner script to do 
      its magic.
   Dfml <file_name> <md5_checksum> <url> 
      The file is downloaded AND checked during the configuration phase. It
      will also be passed to the guest OS.




3.Creating a new configuration
==============================

The configuration files determine what the resulting VM will contain. To make a 
new configuration create a file (ideally in '/home/iedu/Work/virtual_monkey_builder/config/') which initializes the 
following variables:
	
Not changeable yet.
	export check_dependencies=1
	
Name of the bundle containing the ISO, scripts and configurations for a 
specific OS. It has to coincide with the folder name in '/bundles'
	export bundle=""
	
Base OS image options
---------------------
	
Name of the iso file with the base os. In order to take advantage of automatic
setup, it should be the same name as downloaded from the provider.
	export iso_name=""
	
URL for downloading the iso in case it is not found in '/bundles/${bundle}/iso'
	export iso_url=""
	
MD5 sum for the iso file'
	export iso_md5=""
	
OS type as seen by the virtual machine (may differ between different VM
providers)
	export iso_os_type="Ubuntu"
	
Hardware resources
------------------
	
VM type. Will call the appropriate core script. Curretly only 'virtualbox' 
possible
	vm_type=""
	
Allocated RAM for the VM
	export vm_memory=""
	
Number of CPU cores used by the VM
	export vm_cpus=""
	
VM disk size in MB
	export vm_disksize=""
	
Video RAM in MB
	export vm_vram=""
	
User details
------------
	
VM name. Will be the same as the OS hostname.
	export vm_name=""
	
User full name
	export user_fullname=""
	
User login name
	export username=""
	
User password
	export user_password=""
	
Packages
--------
	
Standard package bundles provided with the ISO. Consult the OS manual for
details
	export standard_packages=""
	
Packages from the OS's standard repository (apt-get in Debian distros). Will
be installed during the OS setup, before the provisioner scripts.
	export pre_install_packages=""
	
Provisioners
------------
	
A list of scripts found in '/bundles/${bundle}/provisioners/'. These are shell
scripts written for the provided OS and will be run after the OS setup, during
the monkey's first SSH login. The order provided in the list will be the order
of execution during the provisioning phase.
	export provisioner_scripts=''
	

3.Creating a new bundle
=======================

Creating a new bundle is simple. Just invoke the command

```
./vmb new-bundle <name>
```

and follow the instructions.



4.Creating a new provisioner
============================

To create a new provisioner for a specific bundle you have to write a script in 
the appropriate path (check section 1 for details). A provisioner should be have
two parts: the documentation and the script code. The documentation is written
as a script comment (will be ignored inside the VM), and one should mark the 
beginning and the end with `###begin documentation` and  `###end documentation`
respectively, like in the following:

	###begin documentation##########################################################
	#
	# <your documentation>
	#
	###end documentation############################################################

You can use the following template when creating provisioner scripts:

#!/bin/sh

###begin documentation##########################################################
#
# This is a template showing the structure of a provisioner script. It consists 
# in three sections: preamble, dependency commands, and the actual script code.
# When you make a new bundle, copy this file into the following path:
#    ${VMB_PATH}/bundles/${YOUR_BUNDLE}/provisioners
# and start modifying it to fit your purpose (ideally removing the comments).

# [Preamble]
# Author  : you
# Date    : today
# Purpose : short descrition of what this script does.
# Comment : additional comments and instructions how to acquire the packages

# [Dependencies]
# Here you write the commands describing the packages or files which your 
# provisioner script relies upon. Remember that this whole source will be moved
# inside the guest machine and be executed, thus the dependency commands should
# actually look like comments (start with a # character). They wil be taken care 
# of separately by the Monkey. 
#
# The dependency strings have the following format:
#command [arguments...]
# where <command> defines what arguments are expected. The following strings are 
# accepted (assuming they start at the beginning of a new line):
#   #Df <file_name>                        
#      just a file name (not recommended) 
#   #Dfm <file_name> <md5_checksum>        
#      file name and checksum to verify if it is the correct one
#   #Dl <url>                              
#      just a link. It assumes that the provisioner will download something 
#      inside the guest, and the Monkey just has to verify if the link is active
#   #Dfl <file_name> <url>
#      The file will be downloaded during the configuration phase and copied 
#      inside the guest OS where will be used by the provisioner script to do 
#      its magic.
#   #Dfml <file_name> <md5_checksum> <url> 
#      The file is downloaded AND checked during the configuration phase. It
#      will also be passed to the guest OS.
#
###end documentation############################################################

# [Code]
# here lies your code which does something inside the guest OS. This script will
# be run by The Monkey (actually Packer) on the first login session after the OS
# has been created. Thus, for a UNIX system, it has to be sane shell script code.
