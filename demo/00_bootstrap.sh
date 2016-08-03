#!/bin/sh

HTTP_PROXY=${HTTP_PROXY:-http://proxy-chain.intel.com:911}
cat <<EOF | sudo tee /etc/apt/apt.conf
Acquire::http::Proxy "$HTTP_PROXY";
EOF

sudo apt-get update -y
sudo apt-get install -y openssh-server git

mv ~/.gitconfig ~/.gitconfig.bak
git config --global http.proxy ${HTTP_PROXY}
git clone https://github.com/openstack/fuel-plugin-ovs/
mv ~/.gitconfig.bak ~/.gitconfig
