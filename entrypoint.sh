#!/usr/bin/env bash

if [ -z "$CRON_PURGE" ]
then
  echo "Purge is disabled"
else
  echo "Purging $CRON_PURGE $PURGE_FOLDERS"
  # folders to purge after a certain time
  echo "$CRON_PURGE /root/purge.sh \"$PURGE_FOLDERS\"" > scheduler.txt
fi
echo "Move logs $CRON_MOVELOGS $LOG_FOLDERS"
# folders to move after a certain time (specification on the commandline is possible)
echo "$CRON_MOVELOGS /root/move_logs.sh \"$LOG_FOLDERS\"" >> scheduler.txt

exec supercronic -prometheus-listen-address 0.0.0.0:9080 scheduler.txt
