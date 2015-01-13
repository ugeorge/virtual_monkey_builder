scr=''

progressfilt ()
{
    local flag=false c count cr=$'\r' nl=$'\n'
    while IFS='' read -d '' -rn 1 c
    do
        if $flag
        then
            printf '%c' "$c"
        else
            if [[ $c != $cr && $c != $nl ]]
            then
                count=0
            else
                ((count++))
                if ((count > 1))
                then
                    flag=true
                fi
            fi
        fi
    done
}

function check_file(){
	echo "    Checking if file '$1' exists..."
	if [ ! -f $1 ]; then 
		echo "    WARNING: File '$1' is missing."
		provisioner_scripts=`echo "${provisioner_scripts}" | sed 's:'"$scr"'::g'`
		return 1
	fi
	if [[ ! `echo "$provisioner_files" | grep "$1"` ]]; then
		provisioner_files="$provisioner_files $1"
	fi
	return 0
}

function check_md5sum(){
	md5s=`eval 'md5sum '"$2" | cut -d ' ' -f 1`
	if [[ ${md5s} != ${1} ]]; then 
		echo "    WARNING: MD5 checksum failed for file '$2'"
		echo "             This means that the package is not exactly the same"
		echo "	     as the one tested by the author of this configuration."
		echo "	     Proceed at your own risk!"
	fi;
	return 0
}

function check_url(){
	echo "    Sniffing url $1"
	if [[ ! `wget -S --spider $1 2>&1 | egrep 'HTTP.* 200 OK|File .* exists'` ]]; then 
		echo "    WARNING: Broken link '$1'"
		provisioner_scripts=`echo ${provisioner_scripts} | sed 's:'"$script"'::g'`
		return 1
	fi
	return 0
}

function download_url(){
	echo "    Downloading file '$1' from $2 "
	wget --progress=bar:force $2 -P $PACKAGES_PATH/ 2>&1  | progressfilt
	if [ ! -f $1 ]; then 
		echo "    WARNING: Failed to download file '$1' from $2"
	fi	
	return 0
}

function check_dependency(){
	scr=$1
	depCommand=$2
	case $depCommand in
    f )
		dfile=$PACKAGES_PATH/$3
		check_file $dfile; if [[ $? -eq 1 ]]; then return 1; fi 
		return 0
		;;
    fm )
		dfile=$PACKAGES_PATH/$3
		dmd5=$4
		check_file $dfile; if [[ $? -eq 1 ]]; then return 1; fi 
		check_md5sum $dmd5 $dfile 
		return 0 
		;;
    l )
		durl=$3
		check_url $durl; if [[ $? -eq 1 ]]; then return 1; fi
		return 0
		;;
    fl )
		dfile=$PACKAGES_PATH/$3
		durl=$4
		check_file $dfile
		if [[ $? -eq 0 ]]; then return 0; 
		else 
			check_url  $durl; if [[ $? -eq 1 ]]; then return 1; fi
			download_url $dfile $durl; if [[ $? -eq 1 ]]; then return 1; fi
			return 0
		fi
		;;
    fml )
		dfile=$PACKAGES_PATH/$3
		dmd5=$4
		durl=$5
		check_file $dfile
		if [[ $? -eq 0 ]]; then 
			check_md5sum $dmd5 $dfile;
			return 0; 
		else 
			check_url $durl; if [[ $? -eq 1 ]]; then return 1; fi
			download_url $dfile $durl; if [[ $? -eq 1 ]]; then return 1; fi
			check_md5sum $dmd5 $dfile 
			return 0
		fi
		;;
	*)
		echo "Cannot recognize command $depCommand"
esac
	
}
