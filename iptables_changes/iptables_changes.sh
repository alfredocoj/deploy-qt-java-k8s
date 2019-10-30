#!/bin/bash

echo 1 > /proc/sys/net/ipv4/ip_forward
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf

iptables -F
iptables -t nat -F
iptables -X

iptables -t nat -A PREROUTING -s 192.168.6.95/24 -p tcp -j DNAT --to-destination 10.54.0.95

iptables -t nat -A PREROUTING -s 192.168.6.95 -p tcp --dport 6443 -j DNAT --to-destination 10.54.0.95:6443

iptables -t nat -A PREROUTING -s 192.168.6.96/24 -p tcp -j DNAT --to-destination 10.54.0.96
iptables -t nat -A PREROUTING -s 192.168.6.97/24 -p tcp -j DNAT --to-destination 10.54.0.97
iptables -t nat -A PREROUTING -s 192.168.6.17/24 -p tcp -j DNAT --to-destination 10.54.0.17
iptables -t nat -A PREROUTING -s 192.168.6.131/24 -p tcp -j DNAT --to-destination 10.54.0.31
iptables -t nat -A PREROUTING -s 192.168.6.128/24 -p tcp -j DNAT --to-destination 10.54.0.28

iptables -t nat -A PREROUTING -s 192.168.6.184 -p tcp --dport 5000 -j DNAT --to-destination 10.54.0.184:5000

iptables-save | tee /etc/iptables.rules

mkdir -p /etc/network/if-pre-up.d
echo "#!/bin/bash" > /etc/network/if-pre-up.d/firewall
echo "/sbin/iptables-restore < /etc/iptables.rules" >> /etc/network/if-pre-up.d/firewall

chmod +x /etc/network/if-pre-up.d/firewall

firewall-cmd --reload

