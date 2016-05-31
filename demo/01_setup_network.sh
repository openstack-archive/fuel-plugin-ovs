#!/bin/sh

HTTP_PROXY=${HTTP_PROXY:-http://10.19.8.225:911}
DNS_SERVER=${DNS_SERVER:-10.248.2.1}
SOCKS5_IP=${SOCKS5_IP:-10.7.211.16}
SOCKS5_PORT=${SOCKS5:-1080}

for i in "$@"
do
case $i in
    -h=*|--http=*)
    HTTP_PROXY="${i#*=}"
    shift
    ;;
    -d=*|--dns=*)
    DNS_SERVER="${i#*=}"
    shift
    ;;
    -s=*|--socks5-ip=*)
    SOCKS5_IP="${i#*=}"
    shift
    ;;
    -p=*|--socks5-port=*)
    SOCKS5_PORT="${i#*=}"
    shift
    ;;
    *)
    # unknown option
    ;;
esac
done

cat <<EOF | sudo tee /etc/apt/apt.conf
Acquire::http::Proxy "$HTTP_PROXY";
EOF

sudo apt-get update -y
sudo apt-get install redsocks -y

cat <<EOF | sudo tee /etc/redsocks.conf
base {
 log_debug = on;
 log_info = on;
 log = "file:/root/proxy.log";
 daemon = on;
 redirector = iptables;
}

redsocks {
 local_ip = 0.0.0.0;
 local_port = 6666;
 ip = $SOCKS5_IP;
 port = $SOCKS5_PORT;
 type = socks5;
}

EOF

sudo apt-get install iptables -y

echo  1 | sudo tee /proc/sys/net/ipv4/ip_forward 

sudo iptables -t filter -F
sudo iptables -t mangle -F
sudo iptables -t nat -F

#DNS DNAT
sudo iptables -t nat -A PREROUTING  -p udp --dport 53  -j DNAT --to-destination $DNS_SERVER

#NTP DNAT
sudo iptables -t nat -A PREROUTING  -p udp --dport 123 -j DNAT --to-destination 10.20.0.1

sudo iptables -t nat -A POSTROUTING -s 10.20.0.0/24 -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -s 172.16.0.0/24 -j MASQUERADE

sudo iptables -t nat -N REDSOCKS
sudo iptables -t nat -A REDSOCKS -d 0.0.0.0/8 -j RETURN
sudo iptables -t nat -A REDSOCKS -d 10.0.0.0/8 -j RETURN
sudo iptables -t nat -A REDSOCKS -d 127.0.0.0/8 -j RETURN
sudo iptables -t nat -A REDSOCKS -d 169.254.0.0/16 -j RETURN
sudo iptables -t nat -A REDSOCKS -d 172.16.0.0/12 -j RETURN
sudo iptables -t nat -A REDSOCKS -d 192.168.0.0/16 -j RETURN
sudo iptables -t nat -A REDSOCKS -d 224.0.0.0/4 -j RETURN
sudo iptables -t nat -A REDSOCKS -d 240.0.0.0/4 -j RETURN
sudo iptables -t nat -A REDSOCKS -p tcp -j REDIRECT --to-ports 6666
sudo iptables -t nat -A REDSOCKS -p udp -j REDIRECT --to-ports 9999
sudo iptables -t nat -A OUTPUT -p tcp  -j REDSOCKS
sudo iptables -t nat -A PREROUTING -p tcp  -j REDSOCKS

sudo service redsocks restart
