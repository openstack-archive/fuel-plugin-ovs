#!/bin/bash

DNS_SERVER=${DNS_SERVER:-10.248.2.1}
SUPPORT_DPDK=${SUPPORT_DPDK:-false}

ls *.iso &> /dev/null || (echo "pls download fuel iso here" && exit 0)

#setup ntp server
sudo service ntp restart

#setup network

sudo ifconfig br-eth0 down
sudo brctl delbr br-eth0
sudo brctl addbr br-eth0
sudo ifconfig br-eth0 10.20.0.1/24 up

sudo ifconfig br-eth1 down
sudo brctl delbr br-eth1
sudo brctl addbr br-eth1
sudo ifconfig br-eth1 172.16.0.1/24 up

if [ $SUPPORT_DPDK = 'true' ]
then
    sudo ifconfig br-dpdk down
    sudo brctl delbr br-dpdk
    sudo brctl addbr br-dpdk
fi

sudo iptables -t nat -D PREROUTING  -j PRE_FUEL
sudo iptables -t nat -N PRE_FUEL
sudo iptables -t nat -F PRE_FUEL
sudo iptables -t nat -A PRE_FUEL -p udp --dport 53  -j DNAT --to-destination $DNS_SERVER
sudo iptables -t nat -A PRE_FUEL -p udp --dport 123 -j DNAT --to-destination 10.20.0.1
sudo iptables -t nat -A PREROUTING  -j PRE_FUEL

sudo iptables -t nat -D POSTROUTING  -j POST_FUEL
sudo iptables -t nat -N POST_FUEL
sudo iptables -t nat -F POST_FUEL
sudo iptables -t nat -A POST_FUEL -s 10.20.0.0/24 -j MASQUERADE
sudo iptables -t nat -A POST_FUEL -s 172.16.0.0/24 -j MASQUERADE
sudo iptables -t nat -A POSTROUTING  -j POST_FUEL

#setup master

sudo virt-manager
sudo virsh destroy fuel-master
sudo rm -rf /var/lib/libvirt/images/fuel-master.img
sudo qemu-img create -f qcow2 /var/lib/libvirt/images/fuel-master.img 200G

mkdir -p vms

iso=`pwd`/`ls *.iso`
sed  "s~ISO_FILE~$iso~g" fuel-master.xml > vms/fuel-master.xml

sudo virsh create vms/fuel-master.xml

#login fuel master
sleep 30
rm -rf ~/.ssh/known_hosts
sudo rm -rf ~/.putty
inprog=1
while [ $inprog -ne 0 ]
do
   echo "y\n" | plink -ssh -pw r00tme root@10.20.0.2 "echo y" >& /dev/null
   inprog=$?
   sleep 20
done

plink -ssh  -pw r00tme root@10.20.0.2 "cat /etc/fuel/astute.yaml" > astute.yaml
sed -i "/.*FEATURE_GROUPS.*/s/\[\]/\n \- \"experimental\"/" astute.yaml
cat astute.yaml | plink -ssh  -pw r00tme root@10.20.0.2 "dd of=/etc/fuel/astute.yaml"
plink -ssh  -pw r00tme root@10.20.0.2 "pkill fuelmenu"

inprog=1
while [ $inprog -ne 0 ]
do
   echo "y\n" | plink -ssh -pw r00tme root@10.20.0.2 "grep 'Fuel node deployment complete' /var/log/puppet/bootstrap_admin_node.log "  >& /dev/null
   inprog=$?
   sleep 20
done

if [ $SUPPORT_DPDK = 'true' ]
then
    fuel_slave_xml='fuel-slave-dpdk.xml'
else
    fuel_slave_xml='fuel-slave.xml'
fi
#setup slave
for i in {1..4}; do
    sudo virsh destroy fuel-slave-$i
    sudo rm -rf /var/lib/libvirt/images/fuel-slave-${i}.img
    sudo qemu-img create -f qcow2 /var/lib/libvirt/images/fuel-slave-${i}.img 200G
    sed "s/FUEL_SLAVE/fuel-slave-$i/g" $fuel_slave_xml > vms/fuel-slave-${i}.xml
    sudo virsh create vms/fuel-slave-${i}.xml
done

#setup web browser
firefox https://10.20.0.2:8443 >& /dev/null &
