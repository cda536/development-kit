#!/usr/bin/env bash
# This script will install the current stable AMMDK software stack on an installation of AMMDK Linux

check()
{
    if [ $? -ne 0 ]; then
        exit
    fi
}

echo "Installing dependencies"
sudo apt-mark hold firmware-atheros
sudo apt update -y
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y openocd cmake default-jdk xrdp tigervnc-standalone-server gradle gdb-multiarch tmux libboost-all-dev libtinyxml2-dev gcc-arm-none-eabi rapidjson-dev doxygen sqlite3 libsqlite3-dev sqlite libsqlite-dev man-db nginx supervisor
check

echo "Downloading K66 code"
git clone --recursive https://github.com/AdvancedModularManikin/amm-tiny.git
check
sudo cp amm-tiny/spi_proto/99-spidev-open.rules /etc/udev/rules.d/
check
sudo udevadm control --reload-rules && sudo udevadm trigger
check
pushd amm-tiny/
echo "Building K66 code"
./gencmake.sh
check
make
check
echo "Flashing K66"
./flash.sh debug/amm-tiny.elf
check
popd