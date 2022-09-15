FROM alpine:3.16

LABEL maintainer=digitaal-techniek@vpro.nl

ENV TARGET_FOLDERS="/tmp"
ENV LOG_FOLDERS="/data/logs"
ENV FILE_AGE=1
ENV CRON="* * * * *"
# Optionally use --ctime/--mtime
ENV MARK=""

RUN apk update  --no-cache \
  && apk upgrade --no-cache \
  && apk add --no-cache tzdata bash findutils curl \
  && chgrp -R 0 /root \
  && chmod -R g=u /root


ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.1.12/supercronic-linux-amd64 \
    SUPERCRONIC=supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=048b95b48b708983effb2e5c935a1ef8483d9e3e

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

WORKDIR /root

# We run the crontab entries with a user named 'application' with uid '1001'
RUN addgroup  -S -g 1001 application && \
    adduser -S -u 1001 application -G application --disabled-password --no-create-home --home / && \
    adduser application root && \
    (echo -n poms-plus/garbage-cleaner= ; date -Iseconds) > /DOCKER.BUILD

USER 1001

ENTRYPOINT /root/entrypoint.sh
