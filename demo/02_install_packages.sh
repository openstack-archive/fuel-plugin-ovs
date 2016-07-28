#!/bin/sh

user=`whoami`

cat << EOF | sudo tee /etc/sudoers.d/${user}
${user} ALL = (root) NOPASSWD:ALL
EOF

sudo apt-get update -y
sudo apt-get install openssh-server git -y

#install vnc
sudo apt-get install gnome-session gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal vnc4server -y

#install libvirt/qemu
sudo apt-get install virt-manager libvirt-bin qemu-system -y
sudo virsh net-destroy default
sudo virsh net-undefine default
sudo rm -rf /etc/libvirt/qemu/networks/autostart/default.xml
cat << EOF | sudo tee /etc/libvirt/qemu.conf
user = "root"
group = "root"
EOF

sudo service libvirt-bin restart
sudo ifconfig virbr0 down
sudo brctl delbr virbr0
sudo apt-get install putty-tools -y

#install ntp
sudo service ntp stop
sudo apt-get autoremove ntp -y
sudo apt-get install ntp -y --force-yes
cat << EOF | sudo tee /etc/ntp.conf
server 127.127.1.0
fudge  127.127.1.0 stratum 10
EOF'
sudo service ntp restart
