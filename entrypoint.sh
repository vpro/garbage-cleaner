#!/usr/bin/env bash

echo "$CRON /root/purge.sh $TARGET_FOLDERS
#" > scheduler.txt

echo "@daily /root/move_logs.sh $LOG_FOLDERS
#" >> scheduler.txt

supercronic scheduler.txt
