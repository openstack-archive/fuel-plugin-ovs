#!/bin/bash

sudo virt-manager

#destroy master
sudo virsh destroy fuel-master
sudo rm -rf /var/lib/libvirt/images/fuel-master.img

#destroy slave
for i in {1..4}; do
    sudo virsh destroy fuel-slave-$i
    sudo rm -rf /var/lib/libvirt/images/fuel-slave-${i}.img
done
