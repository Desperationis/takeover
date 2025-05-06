#!/bin/bash
. ../.env
knock $C_SERVER $KNOCK_CLOSE_SSH -d $KNOCK_DELAY
