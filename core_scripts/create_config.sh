#!/bin/bash

export provisioner_files=''

if [ ! -d "$BUND_PATH" ]; then
	read -p " Bundle $bundle does not exist. Create it in $BUNDLES_PATH? [Yn]" yn
    case $yn in
        [Yy]* ) bash core_scripts/new_bundle.sh ${bundle} ${base_os_family} ;;
        [Nn]* ) echo "Aborting"; exit 1;;
        * ) bash core_scripts/new_bundle.sh "$bundle" "$base_os_family"
    esac
fi

if [ ! -f "$BASE_FILE" ]; then
    echo "Base file not found. Retrieving it from the provided url..."
	mkdir -p "$BASE_PATH"
	cd "$BASE_PATH"
	wget "$base_url"
fi
if [ ! -f "$BASE_FILE" ]; then
	echo "Error retrieving the base file. Aboring..."
	exit -1
fi


# Preseed file
if [ "$vm_base_type" = "iso" ]; then
	echo "Generating an OS installation config file..."
	cp "$PRESEED_TEMPLATE" preseed.cfg
	sed -i 's/:(|) USER_FULLNAME (|):/'"$user_fullname"'/' preseed.cfg
	sed -i 's/:(|) USERNAME (|):/'"$username"'/' preseed.cfg
	sed -i 's/:(|) USER_PASSWORD (|):/'"$user_password"'/' preseed.cfg
	sed -i 's/:(|) PRE_INSTALL_PACKAGES (|):/'"$pre_install_packages"'/' preseed.cfg
fi

# Taking care of provisioner scripts dependencies
source $CORE_PATH/check_dependencies.sh
for script in ${provisioner_scripts}; do
	echo "Dependencies: check for script '$script'..."
	dependencies=`grep "^#D" "$PROVISIONERS_PATH"/"$script" | sed 's:\#D*::g'`
	if [ ! -z "$dependencies" ]; then while read -r dep; do
		check_dependency $script $dep
		if [[ $? -eq 1 ]]; then
			echo "Dependencies: not met for '$script'. "
			echo "    Will not be included in the building process!"
			echo "    If you really need it, please provide the dependencies manually:"
			echo "     * open the script '$script' found int '$PROVISIONERS_PATH'"
			echo "     * check which files it depends on (the lines starting with '#D...')"
			echo "     * acquire the package as suggested in the comments"
			echo "     * the package has to have the same name as stated in the dependency "
			echo "       string and (ideally) the same md5 checksum. "
			echo "     * place the package in the '$PACKAGES_PATH' folder."
			echo "     * rerun the configuration command"
			continue 2; 
		fi
	done <<< "$dependencies"; fi
	echo "Dependencies: met for '$script'."
done

# Generate .json file
echo "Generating a Packer template file for building a(n) $vm_type VM from a(n) $vm_base_type base ..."

if [ ! -f $TEMPLATE_PATH/$vm_type-$vm_base_type-$base_os_family.template ]; then
	echo "I do not have a base template for the current configuration. Pease provide the file '$vm_type-$vm_base_type-$base_os_family.template' in $TEMPLATE_PATH"
	echo "Aborting."
	exit -1
fi
cp $TEMPLATE_PATH/$vm_type-$vm_base_type-$base_os_family.template buildscript.json

str=''
if [ ! -z "$provisioner_files" ]; then for file in ${provisioner_files}; do	
	str=''"$str"'\n	{\n		"type": "file",\n		"source": "'"$file"'",\n		"destination": "~/Downloads/'"$(basename $file)"'"\n	},'
done fi
sed -i 's#:(|) PROVISIONER_FILES (|):#'"$str"'#' buildscript.json

str=''
for file in ${provisioner_scripts}; do
	str=''"$str"'\n			"'"$PROVISIONERS_PATH"'/'"$file"'",'
done
sed -i 's#:(|) PROVISIONER_SCRIPTS (|):#'"${str::-1}"'#' buildscript.json

str=''
while read -r line; do
	if [ "$line" != "" ]; then
		tmp=`echo $line | sed 's/\([^" >][^ >]*\)/"\1"/g'`
		tmp=`echo '\n\t\t,['"$tmp"']' | sed 's/ /, /g'`
		tmp=`echo $tmp | sed 's#(_)# #g'`
		str=''"$str""$tmp"
	fi
done <<< "$vm_manage_commands"
sed -i 's#:(|) VM_MANAGE_COMMANDS (|):#'"$str"'#' buildscript.json

str=''
while read -r line; do
	if [ "$line" != "" ]; then
		tmp=`echo $line | sed 's/\([^" >][^ >]*\)/"\1"/g'`
		tmp=`echo '\n\t\t['"$tmp"'],' | sed 's/ /, /g'`
		tmp=`echo $tmp | sed 's#(_)# #g'`
		str=''"$str""$tmp"
	fi
done <<< "$vm_post_manage_commands"
sed -i 's#:(|) VM_POST_MANAGE_COMMANDS (|):#'"${str::-1}"'#' buildscript.json


sed -i 's#:(|) USERNAME (|):#'"$username"'#g' buildscript.json
sed -i 's#:(|) USER_PASSWORD (|):#'"$user_password"'#g' buildscript.json
sed -i 's#:(|) VM_NAME (|):#'"$vm_name"'#g' buildscript.json
sed -i 's#:(|) BASE_OS_TYPE (|):#'"$base_os_type"'#g' buildscript.json
sed -i 's#:(|) VM_VRAM (|):#'"$vm_vram"'#g' buildscript.json
sed -i 's#:(|) VM_MEMORY (|):#'"$vm_memory"'#g' buildscript.json
sed -i 's#:(|) VM_CPUS (|):#'"$vm_cpus"'#g' buildscript.json
sed -i 's#:(|) VM_DISKSIZE (|):#'"$vm_disksize"'#g' buildscript.json
sed -i 's#:(|) BASE_FILE (|):#'"$BASE_FILE"'#g' buildscript.json
sed -i 's#:(|) BASE_MD5 (|):#'"$base_md5"'#g' buildscript.json
sed -i 's#:(|) VM_LANGUAGE (|):#'"$vm_language"'#g' buildscript.json
sed -i 's#:(|) KBD_METHOD (|):#'"$kbd_method"'#g' buildscript.json
sed -i 's#:(|) KBD_LAYOUT (|):#'"$kbd_layout"'#g' buildscript.json
sed -i 's#:(|) KBD_VARIANT (|):#'"$kbd_variant"'#g' buildscript.json

