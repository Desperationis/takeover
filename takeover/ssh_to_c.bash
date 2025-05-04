#!/bin/bash
. .env
knock $C_SERVER $knock_open_ssh -d $knock_delay
ssh root@$C_SERVER
