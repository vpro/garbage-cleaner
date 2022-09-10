#!/usr/bin/env bash

echo "$CRON /root/purge.sh $TARGET_FOLDERS" > scheduler.txt
echo "@daily /root/move_logs.sh $LOG_FOLDERS" >> scheduler.txt

trap stop SIGTERM

start() {
  supercronic scheduler.txt | (echo $! > pid ; tee -a log) &
  echo "Waiting for supercronic"
  tail -F "log" --pid $$  2>/dev/null & tailPid=$!
  wait $tailPid
}
stop() {
  pid=$(cat pid)
  kill -9 $pid
  echo "killed $pid"
  exit 0
}

start


