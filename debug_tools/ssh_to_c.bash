#!/bin/bash
. ../.env
knock $C_SERVER $KNOCK_OPEN_SSH -d $KNOCK_DELAY
ssh root@$C_SERVER
