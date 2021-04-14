FROM debian

ENV TARGET_FOLDERS="/tmp"
ENV FILE_AGE=10s
ENV CRON="* * * * *"
# Optionally use --ctime/--mtime
ENV MARK=""

ADD entrypoint.sh /root/entrypoint.sh
ADD purge.sh /root/purge.sh

RUN apt-get update \
  && apt-get -y install tmpreaper cron \
  && chgrp -R 0 /root \
  && chmod -R g=u /root \
  && chmod -R 774 /var/spool /var/run/ /var/log \
  && chmod +x /root/entrypoint.sh /root/purge.sh

WORKDIR /root

ENTRYPOINT /root/entrypoint.sh
