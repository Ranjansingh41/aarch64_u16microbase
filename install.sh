#!/bin/bash -e

cd /home/shippable/appBase

chown root:root /tmp
chmod 1777 /tmp

echo "================= Updating package lists ==================="
apt-get update

echo "================= Adding some global settings ==================="
mv gbl_env.sh /etc/profile.d/
mkdir -p "$HOME/.ssh/"
mv config "$HOME/.ssh/"
mv 90forceyes /etc/apt/apt.conf.d/
touch "$HOME/.ssh/known_hosts"
mkdir -p /etc/drydock

echo "================= Installing basic packages ==================="
apt-get install -q -y \
  build-essential=12.1* \
  curl=7.47* \
  gcc=4:5.3* \
  gettext=0.19* \
  htop=2.0* \
  libxml2-dev=2.9* \
  libxslt1-dev=1.1* \
  make=4.1* \
  nano=2.5* \
  openssh-client=1:7* \
  openssl=1.0* \
  software-properties-common=0.96* \
  sudo=1.8*  \
  texinfo=6.1* \
  zip=3.0* \
  unzip=6.0* \
  wget=1.17* \
  rsync=3.1* \
  psmisc=22.21* \
  netcat-openbsd=1.105* \
  vim=2:7.4* \
  groff=1.22.*

echo "================= Installing Git ==================="
add-apt-repository ppa:git-core/ppa -y
apt-get update
apt-get install -q -y git=1:2.17.0*

echo "================= Installing core binaries ==================="
add-apt-repository -y ppa:ubuntu-toolchain-r/test
apt-get update

apt-get install -yy g++-4.9

echo "================= Installing Python packages ==================="
apt-get install -q -y \
  python-pip=8.1* \
  python-software-properties=0.96* \
  python-dev=2.7*

pip install -q virtualenv==15.2.0
pip install -q pyOpenSSL==17.5.0
rm -rf /usr/local/lib/python2.7/dist-packages/requests*

echo "================= Adding JQ 1.5.1 ==================="
apt-get install -q jq=1.5*

echo "================= Adding apache libcloud 2.3.0 ============"
sudo pip install 'apache-libcloud==2.3.0'

echo "================= Adding openstack client 3.15.0 ============"
sudo pip install 'python-openstackclient==3.15.0'
sudo pip install 'shade==1.27.1'

echo "================== Installing Nodejs  ====="
NODE_VERSION=v4.8.7
wget https://nodejs.org/dist/"$NODE_VERSION"/node-"$NODE_VERSION"-linux-arm64.tar.xz
tar -xvf node-"$NODE_VERSION"-linux-arm64.tar.xz
cp -Rvf node-"$NODE_VERSION"-linux-arm64/{bin,include,lib,share} /usr/local
npm install -g forever@0.14.2 grunt grunt-cli

echo "================== Installing python requirements ====="
pip install -r /home/shippable/appBase/requirements.txt

echo "================= Intalling Shippable CLIs ================="

git clone https://github.com/Shippable/node.git nodeRepo
./nodeRepo/shipctl/x86_64/Ubuntu_16.04/install.sh
rm -rf nodeRepo

echo "Installed Shippable CLIs successfully"
echo "-------------------------------------"

echo "================= Cleaning package lists ==================="
apt-get clean
apt-get autoclean
apt-get autoremove
