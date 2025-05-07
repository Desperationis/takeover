#!/bin/bash
cd ..
. .env
cd -
knock $C_SERVER $KNOCK_OPEN_TUNNEL -d $KNOCK_DELAY
