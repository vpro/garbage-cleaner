FROM alpine:3.21

LABEL maintainer=digitaal-techniek@vpro.nl

ENV PURGE_FOLDERS="/tmp"
ENV LOG_FOLDERS="/data/logs"
# CRON_PURGE is optional
ENV CRON_PURGE=""
ENV CRON_MOVELOGS="5 * * * *"
ENV FORMAT="removing %Am-%AdT%AH:%AM %Tm-%TdT%TH:%TM %h/%f\n"


RUN apk update  --no-cache \
  && apk upgrade --no-cache \
  && apk add --no-cache tzdata bash findutils curl \
  && chgrp -R 0 /root \
  && chmod -R g=u /root


ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.2.33/supercronic-linux-amd64 \
    SUPERCRONIC=supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=71b0d58cc53f6bd72cf2f293e09e294b79c666d8

RUN curl -fsSLO "$SUPERCRONIC_URL" \
 && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
 && chmod +x "$SUPERCRONIC" \
 && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
 && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic \
 && apk --no-cache del curl

ADD entrypoint.sh /root/entrypoint.sh
ADD purge.sh /root/purge.sh
ADD move_logs.sh /root/move_logs.sh


RUN chmod +x /root/entrypoint.sh /root/purge.sh /root/move_logs.sh

# Have a workable shell
SHELL ["/bin/bash", "-c"]

ENV TZ=Europe/Amsterdam
ENV HISTFILE=/data/.bash_history_cleaner

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# With bearable key bindings:
COPY inputrc /etc

# And a nicer bash prompt
COPY bashrc /.bashrc

# 'When invoked as an interactive shell with the name sh, Bash looks for the variable ENV, expands its value if it is defined, and uses the expanded value as the name of a file to read and execute'
ENV ENV=/.binbash
COPY binbash /.binbash

WORKDIR /root

RUN (echo -n poms/garbage-cleaner= ; date -Iseconds) > /DOCKER.BUILD

EXPOSE 9080

ENTRYPOINT /root/entrypoint.sh

 
