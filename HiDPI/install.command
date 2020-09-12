clear

echo "Administrator required..."
echo -ne "\n"

sudo mount -uw /

C_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $C_DIR

echo "Enable HiDPI"
cd HiDPI_Files/ && ./install.sh && cd ../
echo -ne "\n"


defaultColor="\033[0m"
red="\033[0;31m"

echo -e "$red Installed successful, reboot to take effect! $defaultColor"

exit 0
