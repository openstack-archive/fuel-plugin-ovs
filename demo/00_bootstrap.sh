#!/bin/sh

HTTP_PROXY=${HTTP_PROXY:-http://proxy-chain.intel.com:911}
cat <<EOF | sudo tee /etc/apt/apt.conf
Acquire::http::Proxy "$HTTP_PROXY";
EOF

sudo apt-get update -y
sudo apt-get install -y git openssh-server

git config --global http.proxy ${HTTP_PROXY}
git config --global --unset http.proxy
git clone https://github.com/openstack/fuel-plugin-ovs/
