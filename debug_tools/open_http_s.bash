#!/bin/bash
. .env
knock $C_SERVER $knock_open_http -d $knock_delay
knock $C_SERVER $knock_open_https -d $knock_delay
