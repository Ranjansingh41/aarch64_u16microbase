#!/bin/bash -e

cd /home/shippable/appBase

chown root:root /tmp
chmod 1777 /tmp

echo "================= Updating package lists ==================="
apt-get update

echo "================= Installing core binaries ==================="
add-apt-repository -y ppa:ubuntu-toolchain-r/test
apt-get update

apt-get install -yy g++-4.9

rm -rf /usr/local/lib/python2.7/dist-packages/requests*
pip install --upgrade pip
hash -r

echo "================== Installing python requirements ====="
pip install -r /home/shippable/appBase/requirements.txt

NODE_VERSION=v8.11.3
wget https://nodejs.org/dist/"$NODE_VERSION"/node-"$NODE_VERSION"-linux-arm64.tar.xz
tar -xf node-"$NODE_VERSION"-linux-arm64.tar.xz
cp -Rf node-"$NODE_VERSION"-linux-arm64/{bin,include,lib,share} /usr/local
npm install -g forever@0.14.2 grunt grunt-cli

echo "================= Cleaning package lists ==================="
apt-get clean
apt-get autoclean
apt-get autoremove
