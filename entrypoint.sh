#!/usr/bin/env bash

declare -p | grep -Ev 'BASHOPTS|BASH_VERSINFO|EUID|PPID|SHELLOPTS|UID' > /root/container.env

echo "SHELL=/bin/bash
BASH_ENV=/root/container.env
$CRON /root/purge.sh >> /var/log/cron.log 2>&1
#" > scheduler.txt

crontab scheduler.txt

cron -f
