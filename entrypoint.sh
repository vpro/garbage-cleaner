#!/usr/bin/env bash
# enable job control
set -m

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

trap stop SIGTERM

start() {
  supercronic  -prometheus-listen-address 0.0.0.0:9080  scheduler.txt 2>&1   &
  echo $! > pid
  pid=$(cat pid)
  echo Waiting for $pid now
  wait $pid
}

stop() {
  echo "Received SIGTERM"
  pid=$(cat pid)
  echo "Killing $pid"
  kill -9 $pid
  echo "Killed $pid"
  echo "ready"
  exit 0
}

start
