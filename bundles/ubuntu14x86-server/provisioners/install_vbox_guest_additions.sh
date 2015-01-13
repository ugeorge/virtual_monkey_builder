#!/bin/bash

sudo umount /dev/cdrom
sudo mkdir /media/vboxguest
sudo mount -o loop VBoxGuestAdditions.iso /media/vboxguest
cd /media/vboxguest
sudo ./VBoxLinuxAdditions.run
echo "Finished installing Guest Additions"

echo "Carrying on with the other installations"
