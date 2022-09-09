#!/usr/bin/env bash

echo "$CRON /root/purge.sh $TARGET_FOLDERS" > scheduler.txt
echo "@daily /root/move_logs.sh $LOG_FOLDERS" >> scheduler.txt

trap stop SIGTERM

function start() {
  supercronic scheduler.txt | (echo $! > pid ; tee -a schedule.txt) &
  echo "Waiting for supercronic"
  tail -F "schedule.txt" --pid $$  2>/dev/null & tailPid=$!
  wait $tailPid
}
function stop() {
  pid=$(cat pid)
  kill -9 $pid
  echo "killed $pid"
  exit 0
}

start


