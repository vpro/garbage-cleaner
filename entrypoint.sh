#!/usr/bin/env bash
# enable job control
set -m

echo "$CRON /root/purge.sh $TARGET_FOLDERS" > /etc/crontabs/application
echo "@daily /root/move_logs.sh $LOG_FOLDERS" >> /etc/crontabs/application

trap stop SIGTERM

start() {
# source: `docker run --rm -it alpine  crond -h`
# -f | Foreground
# -d N | Set log level and log to stderr. Most verbose 0, default 8
  crond -f -d 8 2>&1 &
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


