Virtual Monkey Builder
======================

This is the most helpful (and friendly) monkey a(n IT) lab assistant can get. And since
lab assistants are doing all kinds of monkey business, this little guy can be a 
good friend indeed.

This is what our monkey does:

 * build virtual machines (VMs) for lab envirtonments based on your wishes
 * install operating systems inside your VM
 * download, install and set up packages and programs
 * do all sorts of shady things possible through a command-line shell
 * set up environments and get to the innetmost secret places for crazy hacking

And all of this without touching the keyboard. Well... this or crashing and 
burning your computer, killing you and your friends in the process and swinging 
poop at strangers. Did I say it is friendly? Well... umm... it is still an 
experimental project.

The main tool employed by our helpful little monkey is [Packer by HashiCorp](https://www.packer.io/),
which was included in the project source.

Requirements
------------

This tool is (at the moment) entirely build from bash scripts and relies heavily
on UNIX commands, thus it is rather obvious that it was built on and for Linux
operating systems. On the other hand, emulation in Windows with CygWin or similar
tools should be possible, though it was not tested.

Depending on the virtual machine you are targeting you need to install either 
[Virtual Box](https://www.virtualbox.org/) with Extension Pack, or 
~~[VMware Player](https://my.vmware.com/web/vmware/free#desktop_end_user_computing/vmware_player/7_0)
with VIX API.~~(not yet)

Basic usage
-----------

Provided you acquired this wonderful tool in some way or another (ideally by cloning
the master branch) and set it up somewhere you have permission to read, write and execute files, you have to 
`cd` in the installation folder

```
cd /path/to/your/virtual_monkey_buider
```

**ATTENTION** the commands will work only from the program path.

Assuming that you already have a configuration file describing a virtual machine
and its installed components, you have to run:

```
./vmb config <path/to/cfg_file>
```

All configuration files should be in the `config` folder, but there's no one to 
stop you from being messy and placing them wherever. You can create your own 
configuration by modifying `config/config.template` file.

The monkey will start working by checking the dependencies, trying to retreive 
missing files and building two Packer configuration files `preseed.cfg` and 
`buildscript.json`. If some step does not succeed, you will be aggresively prompted
and be faced with in-program solutions. Now don't be a lazy ass, read them! 
It usually involves some cickies here and there, and manually downloading some 
files.

Good, you have the configuration files for your dream virtual machine. Now you 
have to tell the monkey "work!", grab a coffee and enjoy the show. You do that by
typing the command

```
./vmb build
```

Depending on your configuration it may take from a few minutes to a few hours.
But at least the colours are pretty... and they move... You should keep an eye on 
what is happening on the terminal, since if something goes wrong, you will be
prompted.

Voila! You now have a fully functional and set-up virtual machine with your lab
environment. That's it! That wasn't so hard, was it? The VM is in a newly created
folder starting with `output_`. Now you just have to import it into your virtual 
machine player, and play around with it, maybe tweak to satisfy all your
pretentious demands.

Oh, and before I forget... your monkey is a bit messy, it leaves a lot of garbage
behind. To clean up after her, you need to issue the command:

```
./vmb clean
```

That's it!

Of course, you can invoke a help message using 

```
./vmb -h
./vmb <command> -h
```

Advanced usage
--------------

If you want to build your own configurations, add provisioner scripts or even
make your own bundles you need to know a little bit about the project's innards.

To build a documentation of the Monkey's current structure, components and useful 
tips, write

```
./vmb doc [name] [-tree]
```

###Making a new configuration

If you want to add a new configuration based on an existing bundle, you can either
copy an existing configuration or modify a template and fill the variables
according to your preferences. 

Keep in mind that the `provisioner_scripts` variable has to contain names of 
scripts already exising in `<root_monkey>/bundles/<bundle>/provisioners/`.

###Making a new provisioner script

Provisioner scripts are shell scripts which will be run by the monkey inside the
guest OS after its first boot. Thus they have to contain sane shell code. Because
of that, it makes sense to create a set of provisioner scripts for each bundle (each OS).

If the script depends on a file, download link, or whatnot, this dependency has to be 
explicitly stated in a custom command so that the monkey can verify it during
the configuration phase. Check the file `provisioner.template` for extended 
documentation about how to write provisioners.

###Making a new bundle

A bundle consists in

 * a bootable ISO with the OS installation kit
 * a set of provisioner scripts which make sense for that OS
 * a `preseed.template` file for configuring the OS. Some OSes support automatic
   installation through preseed scripts. Check https://gist.github.com/hitsumabushi/11104627 for examples

All the previous steps can be automated using the command

```
./vmb new-bundle <bundle-name>
```

and follow the instructions.

The ISO does not need to be specifically included in the bundle as long as a download
link and a md5 checksum are provided in the configuration file.

Development & contributions
---------------------------

If you find this little monkey useful and have ideas for further extending it, you
are more than welcome to contribute with code or at least open new issues.

Currently I have the following extensions in mind, and I hope to see them implemented
sometimes:
 
 * add support for native VMware builds
 * add support for cloud VMs
 * clean up the code
 * translate the automation scripts to something OS-independent, like python.

License
-------

This project is licensed under [GPLv3](http://www.gnu.org/copyleft/gpl.html) license. 

The VM build engine is [Packer by HashiCorp](https://www.packer.io/), included
in this project and licensed under the [MIT license](http://opensource.org/licenses/MIT).
