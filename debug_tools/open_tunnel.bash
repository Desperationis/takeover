#!/bin/bash
. ../.env
knock $C_SERVER $KNOCK_OPEN_TUNNEL -d $KNOCK_DELAY
