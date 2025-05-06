#!/bin/bash
. .env
knock $C_SERVER $knock_open_tunnel -d $knock_delay
