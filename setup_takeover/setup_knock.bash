#!/bin/bash

########################################################################
########################### KNOCKD SETUP ###############################
########################################################################
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


########################################################################
######################### TUNNEL SETUP #################################
########################################################################

# Restricted access for tunnel user
sudo useradd -m -s /usr/sbin/nologin tunneluser
sudo passwd -l tunneluser  # Lock password login

sudo mkdir -p /home/tunneluser/.ssh
sudo chown tunneluser:tunneluser /home/tunneluser/.ssh
sudo chmod 700 /home/tunneluser/.ssh

# Add public key for compromised machine
PUBLIC_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCvMUG/pA///rdTakZhZJ9en0urbLJIaI/Y9tUI3N5U7ve+ckY/3beiltLKdkgOk7UhqF5soj/+eBZT9E8jPgnH+9MUQVIUSmHsbazPuFyiJ6mr2W5HQsUTJobu8jx5s9tGfMlxbe9py+FKPyz/2QISreEyty0qKgZ5OKPJicRx6SqRAMnef2zlUlBqCcHYqIhHnPO2snWPR8Wlt/VlVrIbi1qpIrkq3hc+W6JyijQAnJg+ze+Unq1S/ROed7L4IR6d4Xmgwe5DwbAQv8ghniW+qk7uG0fJuzaNogYH9zQFqsAYuP7Dm/cvJMDdgpnAS2iDyVKWPPUvVjUAGUoMzUg/BZMXHAg5jlswU/2uB7gG2ZvKNHgCYu636uYiowBdKB8RxFTEhNFNSArkKZJe27bqkHHs8qheRHWCXPdv8D6B85cOEsPrvdjOZxmH6bBXSqalWXVM0IyyZYrA5z52i0cUQcRKo+ZccetzOPu3ReSBLNWEz2QpUx8b8coQVNdxGCHXpBpPmq00HtjzXcyQXpzYJzWY/Cb+RSDAdzBK2kGWgMKAtN2i2sYpL2SMlULxgH/WSzCFOMGApE1B7E4LkKTbeP/dJio+Dsvxde0fTMQb+xDi+xoCPsdxWwe7uDLU1/FpSusieR79hWHa5vYn5ha1Yk0AQyTBXPUk8UNF+oYypQ== compromised only"
echo "$PUBLIC_KEY" > /home/tunneluser/.ssh/authorized_keys
chmod 700 /home/tunneluser/.ssh
chmod 600 /home/tunneluser/.ssh/authorized_keys

sudo tee -a /etc/ssh/sshd_config > /dev/null <<EOF

Match User tunneluser
    AllowTcpForwarding yes
    X11Forwarding no
    PermitTunnel no
    GatewayPorts no
    AllowAgentForwarding no
    ForceCommand echo 'This account is restricted for ssh reverse tunnel use'
    PermitOpen localhost:2222
EOF

sudo sed -i "s|${PUBLIC_KEY}|no-pty,no-agent-forwarding,no-X11-forwarding,permitopen=\"localhost:2222\",command=\"echo 'Tunnel only'\" ${PUBLIC_KEY}|g" /home/tunneluser/.ssh/authorized_keys


echo "Knockd is now setup. Make sure to save the knock order in /etc/knockd.conf before restarting."
