#!/bin/sh

HTTP_PROXY=${HTTP_PROXY:-http://127.0.0.1:1080}
cat <<EOF | sudo tee /etc/apt/apt.conf
Acquire::http::Proxy "$HTTP_PROXY";
EOF

sudo apt-get update -y
sudo apt-get install -y openssh-server git redsocks
