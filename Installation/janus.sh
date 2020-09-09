#!/usr/bin/env bash

echo ">>>>>>>BY JOHN MELODY<<<<<<<<<"
echo ">>> 正在下载 <<< "
wget https://github.com/cisco/libsrtp/archive/v1.5.4.tar.gz
tar xfv v1.5.4.tar.gz
sudo rm -r v1.5.4.tar.gz
cd libsrtp-1.5.4
./configure --prefix=/usr #--enable-openssl
make shared_library && sudo make install
git clone https://gitlab.freedesktop.org/libnice/libnice.git
cd libnice
sudo apt install meson
meson builddir
ninja -C builddir
ninja -C builddir test
sudo ninja -C builddir install
echo "export PKG_CONFIG_PATH=/usr/lib/pkgconfig" >> ~/.bashrc
pkg-config --libs --cflags glib-2.0 -I/usr/local/include/glib-2.0 -I/usr/local/lib/glib-2.0/include -L/usr/local/lib -lglib-2.0
source ~/.bashrc
cd ..
LDFLAGS="-L/usr/local/lib -Wl,-rpath=/usr/local/lib" CFLAGS="-I/usr/local/include"
sudo apt install libnice-dev && y
aptitude install libnanomsg-dev && y
sudo apt-get install aptitude && y
sudo add-apt-repository ppa:eugenesan/ppa
sudo aptitude install libmicrohttpd-dev libjansson-dev \
	libssl-dev libsofia-sip-ua-dev libglib2.0-dev \
	libopus-dev libogg-dev libcurl4-openssl-dev liblua5.3-dev \
	libconfig-dev pkg-config gengetopt libtool automake
sudo aptitude install libnanomsg-dev && y
sudo aptitude install doxygen graphviz && y
git clone https://github.com/meetecho/janus-gateway.git
cd janus-gateway
sh autogen.sh
./configure --prefix=/opt/janus
./configure --prefix /opt/janus LDFLAGS="-L/usr/lib -Wl,-rpath=/usr/lib" CFLAGS="-I/usr/include"
make
sudo make install
sudo make configs
./configure --disable-websockets --disable-data-channels --disable-rabbitmq --disable-mqtt
cd ..
clear 
sudo rm -r janus.sh
echo ">>>>>>>> 安装完成 <<<<<<<<<<<"
sudo apt install janus
janus --help
echo ">>>>>>>> 安装完成 <<<<<<<<<<<"