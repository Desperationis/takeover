#!/bin/bash
cd ..
. .env
cd -
knock $C_SERVER $KNOCK_OPEN_HTTP -d $KNOCK_DELAY
knock $C_SERVER $KNOCK_OPEN_HTTPS -d $KNOCK_DELAY
