#!/bin/bash

sudo apt install -y expect
cat <<EOF | expect
set timeout -1
spawn sudo apt install -y ubuntu-mate-desktop
expect "Default display manager: "
send "lightdm\n"
expect eof
EOF
