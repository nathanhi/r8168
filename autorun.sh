#!/bin/sh

# invoke insmod with all arguments we got
# and use a pathname, as insmod doesn't look in . by default

TARGET_PATH=/lib/modules/`uname -r`/kernel/drivers/net
echo
echo "Check old driver and unload it." 
check=`lsmod | grep r8169`
if [ "$check" != "" ]; then
        echo "rmmod r8169"
        /sbin/rmmod r8169
fi

check=`lsmod | grep r8168`
if [ "$check" != "" ]; then
        echo "rmmod r8168"
        /sbin/rmmod r8168
fi

echo "Build the module and install"
echo "-------------------------------" >> log.txt
date 1>>log.txt
make all 1>>log.txt || exit 1
module=`ls src/*.ko`
module=${module#src/}
module=${module%.ko}

if [ "$module" == "" ]; then
	echo "No driver exists!!!"
	exit 1
elif [ "$module" != "r8169" ]; then
	if test -e $TARGET_PATH/r8169.ko ; then
		echo "Backup r8169.ko"
		if test -e $TARGET_PATH/r8169.bak ; then
			i=0
			while test -e $TARGET_PATH/r8169.bak$i
			do
				i=$(($i+1))
			done
			echo "rename r8169.ko to r8169.bak$i"
			mv $TARGET_PATH/r8169.ko $TARGET_PATH/r8169.bak$i
		else
			echo "rename r8169.ko to r8169.bak"
			mv $TARGET_PATH/r8169.ko $TARGET_PATH/r8169.bak
		fi
	fi
fi

echo "Depending module. Please wait."
depmod -a
echo "load module $module"
modprobe $module

echo "Completed."
exit 0
