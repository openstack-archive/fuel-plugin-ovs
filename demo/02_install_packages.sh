#!/bin/sh

cat << EOF | sudo tee /etc/sudoers.d/fuel
fuel ALL = (root) NOPASSWD:ALL
EOF

sudo apt-get update -y
sudo apt-get install openssh-server -y
sudo apt-get autoremove gnome-settings-daemon-schemas -y
sudo apt-get autoremove libmetacity-private0a metacity-common -y
sudo apt-get install gnome-session gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal -y
sudo apt-get install virt-manager libvirt-bin qemu-system -y
sudo virsh net-destroy default
sudo virsh net-undefine default
sudo rm -rf /etc/libvirt/qemu/networks/autostart/default.xml
sudo service libvirt-bin restart
sudo ifconfig virbr0 down
sudo brctl delbr virbr0
sudo apt-get install putty-tools -y
sudo service ntp stop
sudo apt-get autoremove ntp -y
sudo rm -rf /etc/ntp.conf.dpkg-old
sudo rm -rf /etc/ntp.conf
sudo apt-get install ntp -y --force-yes
sudo bash -c 'cat << EOF >> /etc/ntp.conf
server 127.127.1.0
fudge  127.127.1.0 stratum 10
EOF'
