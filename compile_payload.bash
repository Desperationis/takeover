#!/bin/bash

# We need a lot of info in one script file, so this substitutes all env
# variables in the script.sh to make it specific to our install
if [[ -d payload ]]
then
    rm -rf payload
fi

mkdir payload

export SERVER_PUBLIC_KEY=$(cat ssh/CENTRAL.pub)
export SERVER_TUNNEL_KNOCKD_COMBO="11114 22224"
export SERVER_TUNNEL_PORT=9999
export SERVER_IP=128.199.5.97

envsubst < ducky/script.sh > payload/payload.sh


