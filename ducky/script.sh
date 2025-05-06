#!/bin/bash

set -euo pipefail

# Allow server to login to us
mkdir -p ~/.ssh
chmod 700 ~/.ssh
echo "$SERVER_PUBLIC_KEY" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
echo "Injected server public key."

# Bypass server firewall via knock
for port in $KNOCK_OPEN_TUNNEL; do echo | nc $C_SERVER $port; sleep 0.1; done


echo "Connecting via ssh..."
ssh -N -o StrictHostKeyChecking=accept-new -R $SERVER_TUNNEL_PORT:localhost:22 root@$C_SERVER
