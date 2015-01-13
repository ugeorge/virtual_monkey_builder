mkdir -p $BUNDLES_PATH/$1
if [ ! -z $2 ];then distro=$2
else read -p "What distribution is the bunde's OS? [ubuntu|debian]" distro
fi
case "$distro" in
	ubuntu) 
		cp $TEMPLATE_PATH/preseed-ubuntu.template $BUNDLES_PATH/$1/preseed.template
		;;
	debian) 
		cp $TEMPLATE_PATH/preseed-debian.template $BUNDLES_PATH/$1/preseed.template
		;;
	*) 
		echo "I do not know this distribution. You will have to fill in the  following files in $BUNDLES_PATH/$1"
		echo "  * preseed.template"
		touch $BUNDLES_PATH/$1/preseed.template
		exit -1 
esac
mkdir -p $BUNDLES_PATH/$1/bases
mkdir -p $BUNDLES_PATH/$1/provisioners
cp $TEMPLATE_PATH/provisioner.template $BUNDLES_PATH/$1/provisioners/provisioner.template
