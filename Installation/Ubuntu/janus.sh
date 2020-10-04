#!/usr/bin/env bash

echo ">>>>>>>BY JOHN MELODY<<<<<<<<<"
echo ">>> 正在下载 <<< "
sleep 2
# sudo ufw status
wget https://github.com/coturn/coturn/archive/4.5.1.3.tar.gz
tar xvfz 4.5.1.3.tar.gz && sudo rm -r 4.5.1.3.tar.gz
cd coturn-4.5.1.3
sudo apt-get install gdebi-core
./configure --prefix=/usr/local/coturn
make
sudo make install
cd /usr/local/coturn/etc && ls 
sudo cp turnserver.conf.default turnserver.conf
cd .. && cd ..
sleep 2
# sudo systemctl status apache2
sudo apt install net-tools
sudo apt-get install coturn
sudo apt install nodejs
sudo apt install npm
wget https://gitlab.gnome.org/GNOME/glib/-/archive/master/glib-master.tar.gz
tar xf glib-master.tar.gz
cd glib-master  
meson _build
ninja -C _build
ninja -C _build install 
cd ..
sudo apt-get install glade
wget https://github.com/cisco/libsrtp/archive/v1.5.4.tar.gz
wget http://archive.ubuntu.com/ubuntu/pool/universe/libs/libsrtp2/libsrtp2-dev_2.1.0-1_amd64.deb
sudo dpkg -i libsrtp2-dev_2.1.0-1_amd64.deb
# sudo apt-get install libgtk2.0-dev
sudo apt-get install libglib2.0-dev
tar xfv v1.5.4.tar.gz
sudo rm -r v1.5.4.tar.gz
cd libsrtp-1.5.4
./configure --prefix=/usr #--enable-openssl
make shared_library && sudo make install
git clone https://gitlab.freedesktop.org/libnice/libnice.git
cd libnice
 sudo apt --fix-broken install
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
cd ..
git clone https://github.com/meetecho/janus-gateway.git
cd janus-gateway
sh autogen.sh
./configure --prefix=/opt/janus
./configure --prefix /opt/janus LDFLAGS="-L/usr/lib -Wl,-rpath=/usr/lib" CFLAGS="-I/usr/include"
make
sudo make install
sudo make configs
./configure --disable-websockets --disable-data-channels --disable-rabbitmq --disable-mqtt --disable-aes-gcm
cd ..
cp /janus-gateway /var/
sudo apt install nginx
service nginx start
clear 
sudo rm -r janus.sh
# echo ">>>>>>>> 安装完成 <<<<<<<<<<<"
sudo apt install janus
sudo apt-get -y update && sudo apt-get -y upgrade 
echo ">>>>>>>> 安装完成 <<<<<<<<<<<"
sleep 3
janus --help
