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
sudo iptables -A INPUT -p tcp --dport 9999 -j REJECT

sudo systemctl enable netfilter-persistent
sudo systemctl start netfilter-persistent
sudo netfilter-persistent save
sudo netfilter-persistent reload

echo "$KNOCKD_CONF" >> /etc
echo "$KNOCKD_CONF2" >> /etc/default/

sudo systemctl enable knockd
sudo systemctl start knockd


########################################################################
######################## ATTACKER SETUP ################################
########################################################################
mkdir -p ~/.ssh
chmod 700 ~/.ssh
echo "$ATTACKER_PUBLIC_KEY" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys


echo "Knockd is now setup. Make sure to save the knock order in /etc/knockd.conf before restarting."
