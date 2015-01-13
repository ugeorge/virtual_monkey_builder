echo "
--------------------------------------------------------------------------------

                    Virtual Monkey Builder (VMB-$VERSION)
                       - generated documentation -

--------------------------------------------------------------------------------

Base folder: $HOME_PATH

Please check README.md for general usage and command-line options." > $docfile

if [ ! -z $printtree ]; then 
echo "
0.Directory structure
=====================" >> $docfile
if ! type tree > /dev/null; then
	echo "INFO: The 'tree' command is not available. For a nice display of the folder
	structure, install 'tree' e.g.: sudo apt-get install tree" >> $docfile
	find . -maxdepth 4 -not -path '*/\.*' -not -path '*/packer*' >> $docfile
else
	tree -L 4 -I 'packer|*~' . >> $docfile
fi
echo '' >> $docfile
fi

bundles=`find $BUNDLES_PATH -maxdepth 1 -mindepth 1 -type d -exec basename {} \;`
prov=''

echo "
1.Available bundles
===================

I have found the following bundles:" >> $docfile

for bun in ${bundles}; do
	echo "  * $bun" >> $docfile
	if [ ! -d "$BUNDLES_PATH/$bun/bases" ]; then
		echo "    ├─ WARNING: This bunde has no base. The configuration stage should take care of this." >> $docfile
	else 
		echo "    ├─ base OS iso : `ls $HOME_PATH/bundles/$bun/bases/*.iso`" >> $docfile
	fi
	echo "    ├─ and provisioners:" >> $docfile
	provisioners=`find $HOME_PATH/bundles/$bun/provisioners -maxdepth 1 -mindepth 1 -not -path '*~' -not -path '*#'`
	prov="$prov $provisioners"
	for pr in ${provisioners}; do
		echo "       ├─ `basename $pr`" >> $docfile
	done
done
echo '' >> $docfile

echo "
2.Documentation for available provisioners
==========================================

The provisioners can be seen in section '1.Available bundles'. They are scripts 
which are run initially inside the VM to install different software components.
The following paragraphs show their documentation as it is provided:
" >> $docfile

for pr in ${prov}; do
	sed -n "/###begin documentation/,/###end documentation/p" $pr > .temp
	sed -i 's/###begin documentation//g' .temp
	sed -i 's/###end documentation//g' .temp
	sed -i 's/#//g' .temp
	if  [ -s .temp ]; then
		echo "$pr" >> $docfile
		echo "--------------------------------------" >> $docfile
		cat .temp >> $docfile
	fi
done

echo '' >> $docfile

echo "
3.Creating a new configuration
==============================

The configuration files determine what the resulting VM will contain. To make a 
new configuration create a file (ideally in '$CONFIG_PATH/') which initializes the 
following variables:" >> $docfile

touch .temp
sed 's/^/\t/' $TEMPLATE_PATH/config.template > .temp
sed -i 's/	# //g' .temp
cat .temp >> $docfile

echo "
3.Creating a new bundle
=======================

Creating a new bundle is simple. Just invoke the command

\`\`\`
./vmb new-bundle <name>
\`\`\`

and follow the instructions.

" >> $docfile


echo "
4.Creating a new provisioner
============================

To create a new provisioner for a specific bundle you have to write a script in 
the appropriate path (check section 1 for details). A provisioner should be have
two parts: the documentation and the script code. The documentation is written
as a script comment (will be ignored inside the VM), and one should mark the 
beginning and the end with \`###begin documentation\` and  \`###end documentation\`
respectively, like in the following:

	###begin documentation##########################################################
	#
	# <your documentation>
	#
	###end documentation############################################################

You can use the following template when creating provisioner scripts:
" >> $docfile

cat $TEMPLATE_PATH/provisioner.template  >> $docfile

rm .temp
