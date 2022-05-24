FROM debian:buster
# it seems we use debian because it provides tmpreaper
# it'll cost about 150Mb in comparison with alpine.
# is that worth it?

ENV TARGET_FOLDERS="/tmp"
ENV LOG_FOLDERS="/data/logs"
ENV FILE_AGE=10s
ENV CRON="* * * * *"
ENV MAX_RUNTIME=600
# Optionally use --ctime/--mtime
ENV MARK=""

ADD entrypoint.sh /root/entrypoint.sh
ADD purge.sh /root/purge.sh
ADD move_logs.sh /root/move_logs.sh


RUN apt-get update \
  && apt-get -y install tmpreaper curl \
  && chgrp -R 0 /root \
  && chmod -R g=u /root \
  && chmod +x /root/entrypoint.sh /root/purge.sh /root/move_logs.sh


ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.1.12/supercronic-linux-amd64 \
    SUPERCRONIC=supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=048b95b48b708983effb2e5c935a1ef8483d9e3e

RUN curl -fsSLO "$SUPERCRONIC_URL" \
 && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
 && chmod +x "$SUPERCRONIC" \
 && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
 && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic \
 && apt-get -y autoremove curl


# Have a workable shell
SHELL ["/bin/bash", "-c"]

ENV TZ=Europe/Amsterdam
ENV HISTFILE=/data/.bash_history_cleaner

RUN echo "dash dash/sh boolean false" | debconf-set-selections &&  DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash ; exit 0 && \
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
  dpkg-reconfigure --frontend noninteractive tzdata


# With bearable key bindings:
COPY inputrc /etc

# And a nicer bash prompt
COPY bashrc /.bashrc


WORKDIR /root

# We run always with a user named 'application' with uid '1001'
RUN addgroup  --system --gid 1001 application && \
    adduser --system --uid 1001 application --gid 1001 --disabled-password --no-create-home --home / && \
    adduser application root && \
    date > /garbage-cleaner.build

USER 1001

ENTRYPOINT /root/entrypoint.sh
