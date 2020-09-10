#!/usr/bin/env bash
# MACOSX

echo "配置........"
brew install jansson libnice openssl srtp libusrsctp libmicrohttpd \
	libwebsockets cmake rabbitmq-c sofia-sip opus libogg curl glib \
	libconfig pkg-config gengetopt autoconf automake libtool
mkdir deps
cd deps
wget https://github.com/cisco/libsrtp/archive/v1.5.4.tar.gz
tar xfv v1.5.4.tar.gz
cd libsrtp-1.5.4
./configure --prefix=/usr --enable-openssl
make shared_library && sudo make install
echo "配置........"
cd ..
wget https://github.com/cisco/libsrtp/archive/v2.2.0.tar.gz
tar xfv v2.2.0.tar.gz
cd libsrtp-2.2.0
./configure --prefix=/usr --enable-openssl
make shared_library && sudo make install
echo "配置........"
cd ..
git clone https://boringssl.googlesource.com/boringssl
cd boringssl
# Don't barf on errors
sed -i s/" -Werror"//g CMakeLists.txt
# Build
mkdir -p build
cd build
cmake -DCMAKE_CXX_FLAGS="-lrt" ..
make
echo "配置........"
cd ..
# Install
sudo mkdir -p /opt/boringssl
sudo cp -R include /opt/boringssl/
sudo mkdir -p /opt/boringssl/lib
sudo cp build/ssl/libssl.a /opt/boringssl/lib/
sudo cp build/crypto/libcrypto.a /opt/boringssl/lib/
cd ..
echo "配置........"
git clone https://github.com/meetecho/janus-gateway.git
cd janus-gateway
./configure --prefix=/usr/local/janus PKG_CONFIG_PATH=/usr/local/opt/openssl/lib/pkgconfig
clear
echo "完毕........"
janus --help