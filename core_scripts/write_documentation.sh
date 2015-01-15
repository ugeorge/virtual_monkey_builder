echo "

Virtual Monkey Builder (VMB-$VERSION)
=====================================

_This is a generated documentation for helping VMB users create own configurations 
or bundles_

For a list of command-line options and basic tool usage, please check \`README.md\`
found in the base folder.

Base folder: \`$HOME_PATH\`

" > $docfile

if [ ! -z $printtree ]; then echo "*   [Directory structure](#Directory structure)" >> $docfile; fi

echo "*   [Configurations](#Configurations)" >> $docfile
echo "	*   [Available configurations](#Available configurations)" >> $docfile
echo "	*   [Creating a new configuration](#Creating a new configuration)" >> $docfile
echo "*   [Bundles](#Bundles)" >> $docfile
echo "	*   [Available bundles](#Available bundles)" >> $docfile
echo "	*   [Creating a new bundle](#Creating a new bundle)" >> $docfile
echo "*   [Provisioners](#Provisioners)" >> $docfile
echo "	*   [Available provisioners](#Available provisioners)" >> $docfile
echo "	*   [Creating a new provisioner](#Creating a new provisioner)" >> $docfile

if [ ! -z $printtree ]; then 
echo "
Directory structure
-------------------" >> $docfile
if ! type tree > /dev/null; then
	echo "INFO: The 'tree' command is not available. For a nice display of the folder
	structure, install 'tree' e.g.: sudo apt-get install tree" >> $docfile
	find . -maxdepth 4 -not -path '*/\.*' -not -path '*/packer*' >> $docfile
else
	tree -L 4 -I 'packer|*~' . >> $docfile
fi
echo '' >> $docfile
fi

echo "
Configurations
--------------

A configuration file defines a set of variables which tell the monkey how to set
up your machine, e.g. names, VM parameters, what provisioner scripts to run inside
the VM (a.k.a building blocks), etc

" >> $docfile

echo "
###Available configurations

I have found the following configurations:" >> $docfile

for cf in `find config -type f \( ! -iname "*template" ! -iname "README*" ! -iname "*~" ! -iname "*#" \) `; do
		echo "
 * **\`$cf\`**" >> $docfile
	sed -n "/###:(|)/,/###(|):/p" $cf > .temp
	sed -i 's/###:(|)//g' .temp
	sed -i 's/###(|)://g' .temp
	sed -i 's/#//g' .temp
	sed -i ':a;N;$!ba;s/\n/\n    /g' .temp
	if  [ -s .temp ]; then
		echo "
********************************************************************************" >> $docfile
		cat .temp >> $docfile
		echo "
********************************************************************************" >> $docfile
	fi
done

echo "
###Creating a new configuration

The configuration files determine what the resulting VM will contain. To make a 
new configuration create a file (ideally in \`$CONFIG_PATH/\`) which initializes the 
following variables:" >> $docfile

touch .temp
sed '/^#/! s/^/\n    /g' $TEMPLATE_PATH/config.template > .temp
sed -i 's/# //g' .temp
sed -i 's/\[/####/g' .temp
sed -i 's/\]//g' .temp
cat .temp >> $docfile

echo "
Bundles
-------

A bundle is a collection of \"lego blocks\" for the monkey to play with when 
building your virtual machine. A bundle is associated with _one OS distribution 
**ONLY**_. All bundles should be placed in \`$BUNDLES_PATH\` and should have the
following folder structure

 * \`bases\`: a folder containing all bases associated with that OS distribution.
   This can include ISO files with boot CDs or other virtual machine files (OVF or 
   VIX) with pre-installed OSes
 * \`provisioners\`: a folder containing all the scripts which \"do something\" 
   inside that OS distribution and which the monkey run without you touching the 
   keyboard.
 * \`preseed.templace\`: an OS pre-configuration template which works with that
   OS distribution. It is used when you build virtual machine from base ISO and
   automates the OS boot/installation process.

" >> $docfile

bundles=`find $BUNDLES_PATH -maxdepth 1 -mindepth 1 -type d -exec basename {} \;`
prov=''

echo "
###Available bundles


I have found the following bundles:
" >> $docfile

for bun in ${bundles}; do
	echo "  * $bun" >> $docfile
	echo "    - path : \` $HOME_PATH/bundles/$bun\`" >> $docfile
	if [ ! -d "$BUNDLES_PATH/$bun/bases" ]; then
		echo "    - WARNING: This bunde has no base. The configuration stage should take care of this." >> $docfile
	else 
		echo "    - base OS files : \``ls $HOME_PATH/bundles/$bun/bases/*.iso | tr '\n' '\0' | xargs -0 -n 1 basename`\`" >> $docfile
	fi
	echo "    - and provisioners: ([documentation](#Available provisioners))" >> $docfile
	provisioners=`find $HOME_PATH/bundles/$bun/provisioners -maxdepth 1 -mindepth 1 -not -path '*~' -not -path '*#'`
	prov="$prov $provisioners"
	for pr in ${provisioners}; do
		echo "       - \``basename $pr`\`" >> $docfile
	done
done
echo '' >> $docfile

echo "
###Creating a new bundle


Creating a new bundle is simple. Just invoke the command

    ./vmb new-bundle <name>

and follow the instructions. If you're lucky and the monkey knows your OS distro,
it will be nice and provide you a \`preseed.template\` file. Otherwise you will
have to write it by yourself.

" >> $docfile


echo "
Provisioners
------------

Provisioner scripts are shell scripts which will be run by the monkey inside the
guest OS after its first boot. Thus they have to contain sane shell code. Because
of that, it makes sense to create a set of provisioner scripts for each bundle (each OS).

If the script depends on a file, download link, or whatnot, this dependency is 
explicitly stated in a custom command so that the monkey can verify it during
the configuration phase. Check the file \`provisioner.template\` for extended 
documentation about how to write provisioners.

" >> $docfile

echo "
###Documentation for available provisioners

The provisioners can be seen in section [Available bundles](#Available bundles). 
The following paragraphs show their documentation as it is provided:
" >> $docfile

for pr in ${prov}; do
	sed -n "/###begin documentation/,/###end documentation/p" $pr > .temp
	sed -i 's/###begin documentation//g' .temp
	sed -i 's/###end documentation//g' .temp
	sed -i 's/#//g' .temp
	sed -i ':a;N;$!ba;s/\n/\n    /g' .temp
		echo "
 * **\`$pr\`**" >> $docfile
	if  [ -s .temp ]; then
		echo "
********************************************************************************" >> $docfile
		cat .temp >> $docfile
		echo "
********************************************************************************" >> $docfile
	fi
done

echo '' >> $docfile


echo "
###Creating a new provisioner

To create a new provisioner for a specific bundle you have to write a script in 
the appropriate path (check section 1 for details). A provisioner should be have
two parts: the documentation and the script code. The documentation is written
as a script comment (will be ignored inside the VM), and one should mark the 
beginning and the end with \`###:(|)\` and  \`###(|):\`
respectively, like in the following:

	###:(|)#########################################################################
	#
	# <your documentation>
	#
	###(|):#########################################################################

You can use the following template when creating provisioner scripts:
" >> $docfile

sed 's/^/    /g' $TEMPLATE_PATH/provisioner.template >> $docfile

rm .temp
