#!/bin/bash

pushd `dirname $0` > /dev/null
dir=`pwd`
popd > /dev/null

export VERSION="0.1.1"
export HOME_PATH=$dir
export BUNDLES_PATH=$dir/bundles
export CORE_PATH=$dir/core_scripts
export CONFIG_PATH=$dir/config
export DOC_PATH=$dir/doc
export PACKAGES_PATH=$dir/packages
export TEMPLATE_PATH=$dir/templates

if [[ `echo "$1" | egrep 'config|conf|configure'` ]]; then
	if [ -z "$2" ]; then echo "Please provide a configuration file"; exit -1; else cfgfile=$2; fi
	
	source $cfgfile
	export BUND_PATH=$BUNDLES_PATH/$bundle
	export BASE_PATH=$BUND_PATH/bases
	export BASE_FILE=$BASE_PATH/$base_name
	export PRESEED_TEMPLATE=$BUND_PATH/preseed.template
	export PROVISIONERS_PATH=$BUND_PATH/provisioners

	bash core_scripts/create_config.sh
fi

if [[ `echo "$1" | grep 'build'` ]]; then 
	eval "$dir"'/packer/packer build '"$dir"'/buildscript.json'
fi
if [[ `echo "$1" | grep 'clean'` ]]; then 
	rm -rf packer_*
	rm preseed.cfg
	rm buildscript.json
fi
if [[ `echo "$1" | egrep 'doc|documentation|docs'` ]]; then
	if [[ $@ =~ "-tree" ]]; then export printtree="true"; fi
	export docfile="$DOC_PATH/Documentation.md"
	mkdir -p $DOC_PATH

	bash core_scripts/write_documentation.sh
 	if [ -z `command -v markdown` ]; then
		echo "
It seems that you do not have markdown installed. It is a nice tool that converts
md files to html. In order to experience the full beauty of this monkey-generated
document, install it e.g. on Debian distributions:
    sudo apt-get install markdown

Generated $DOC_PATH/Documentation.md
" 
		exit 1
	fi
	markdown $DOC_PATH/Documentation.md > $DOC_PATH/Documentation.html
	echo "Generated:
 * $DOC_PATH/Documentation.md
 * $DOC_PATH/Documentation.html"
fi
if [[ `echo "$1" | egrep 'new-bundle'` ]]; then
	if [ -z "$2" ]; then echo "Please provide a name for the new bundle" 
	else
		bash core_scripts/new_bundle.sh $2
	fi
fi


