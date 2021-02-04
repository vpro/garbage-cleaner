FROM debian

ENV TARGET_FOLDERS="/tmp"
ENV FILE_AGE_MINUTES=10
ENV INTERVAL_MINUTES=10

ADD entrypoint.sh /root/entrypoint.sh

RUN apt-get update \
  && apt-get -y install tmpreaper \
  && chgrp -R 0 /root \
  && chmod -R g=u /root \
  && chmod +x /root/entrypoint.sh

ENTRYPOINT /root/entrypoint.sh


