#!/bin/bash
. .env
knock $C_SERVER $knock_close_ssh -d $knock_delay
