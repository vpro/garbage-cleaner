FROM alpine:3.17

LABEL maintainer=digitaal-techniek@vpro.nl

ENV PURGE_FOLDERS="/tmp"
ENV LOG_FOLDERS="/data/logs"
# CRON_PURGE is optional
ENV CRON_PURGE=""
ENV CRON_MOVELOGS="5 * * * *"

RUN apk update  --no-cache \
  && apk upgrade --no-cache \
  && apk add --no-cache tzdata bash findutils curl \
  && chgrp -R 0 /root \
  && chmod -R g=u /root


ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.2.1/supercronic-linux-amd64 \
    SUPERCRONIC=supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=d7f4c0886eb85249ad05ed592902fa6865bb9d70

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

ENV ENV=/.binbash
COPY binbash /.binbash

WORKDIR /root

# We run the crontab entries with a user named 'application' with uid '1001'
RUN addgroup  -S -g 1001 application && \
    adduser -S -u 1001 application -G application --disabled-password --no-create-home --home / && \
    adduser application root && \
    (echo -n poms-plus/garbage-cleaner= ; date -Iseconds) > /DOCKER.BUILD

USER 1001
EXPOSE 9080

ENTRYPOINT /root/entrypoint.sh
