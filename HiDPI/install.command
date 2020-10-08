clear

echo "Administrator Required!"
echo -ne "\n"

sudo mount -uw /

C_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $C_DIR

echo "Processing..."
cd HiDPI/ && ./install.sh && cd ../
echo -ne "\n"


defaultColor="\033[0m"
red="\033[0;31m"

echo -e "Successful, please reboot to take effect!"

exit 0
