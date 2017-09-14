#!/bin/bash -e

cd /home/shippable/appBase

chown root:root /tmp
chmod 1777 /tmp

echo "================= Updating package lists ==================="
apt-get update -qq

echo "================= Installing core binaries ==================="
add-apt-repository -y ppa:ubuntu-toolchain-r/test
#echo "deb http://archive.ubuntu.com/ubuntu xenial main universe restricted multiverse" > /etc/apt/sources.list
apt-get update -qq

apt-get install -qq -yy g++-4.9

rm -rf /usr/local/lib/python2.7/dist-packages/requests*
pip install --upgrade pip
hash -r

echo "================== Installing python requirements ====="
pip install -r /home/shippable/appBase/requirements.txt

wget https://nodejs.org/dist/v4.8.0/node-v4.8.0-linux-arm64.tar.xz
tar -xvf node-v4.8.0-linux-arm64.tar.xz
cp -Rvf node-v4.8.0-linux-arm64/{bin,include,lib,share} /usr/local
npm install -g forever@0.14.2 grunt grunt-cli

echo "================= Cleaning package lists ==================="
#apt-get purge libapparmor1 #Yes, do as I say!
apt-get clean
apt-get autoclean
apt-get autoremove
