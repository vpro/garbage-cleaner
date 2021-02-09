FROM debian

ENV TARGET_FOLDERS="/tmp"
ENV FILE_AGE=10s
ENV INTERVAL=10s
# Optionally use --ctime/--mtime
ENV MARK=""

ADD entrypoint.sh /root/entrypoint.sh

RUN apt-get update \
  && apt-get -y install tmpreaper \
  && chgrp -R 0 /root \
  && chmod -R g=u /root \
  && chmod +x /root/entrypoint.sh

ENTRYPOINT /root/entrypoint.sh


