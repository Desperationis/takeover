#!/bin/bash

sudo apt-get install -y knockd
sudo apt-get install -y iptables-persistent 

# Don't block current ssh access
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 22 -j REJECT
sudo iptables -A INPUT -p tcp --dport 80 -j REJECT
sudo iptables -A INPUT -p tcp --dport 443 -j REJECT

sudo systemctl enable netfilter-persistent
sudo systemctl start netfilter-persistent
sudo netfilter-persistent save
sudo netfilter-persistent reload

mv knockd.conf /etc
mv knockd /etc/default/

sudo systemctl enable knockd
sudo systemctl start knockd

echo "Knockd is now setup. Make sure to save the knock order in /etc/knockd.conf before restarting."
