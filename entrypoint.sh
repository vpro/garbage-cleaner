#!/usr/bin/env bash
# enable job control
set -m

# folders to purge after a certain time
echo "$CRON_PURGE /root/purge.sh \"$TARGET_FOLDERS\"" > scheduler.txt
# folders to move after a certain time (specification on the commandline is possible)
echo "$CRON_MOVELOGS /root/move_logs.sh \"$LOG_FOLDERS\"" >> scheduler.txt

trap stop SIGTERM

start() {
  supercronic scheduler.txt 2>&1 &
  echo $! > pid
  fg
  echo "Cron stopped"
}
stop() {
  pid=$(cat pid)
  kill -9 $pid
  echo "killed $pid"
  exit 0
}

start


