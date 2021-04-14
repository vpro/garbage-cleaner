#!/usr/bin/env bash

echo "$CRON /root/purge.sh
#" > scheduler.txt

supercronic scheduler.txt
