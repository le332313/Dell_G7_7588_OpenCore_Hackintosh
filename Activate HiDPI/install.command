#!/bin/bash

#set -x

clear

echo "Administrator Required!"
echo -ne "\n"

sudo mount -uw /

C_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $C_DIR #navigate to path where install.sh was invoked

echo "Activating HiDPI..."
cd HiDPI/ && ./install.sh && cd ../
echo -ne "\n"


defaultColor="\033[0m"
red="\033[0;31m"

echo -e "Installed successful, please reboot to take effect!"

exit 0
