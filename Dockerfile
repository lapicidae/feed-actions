FROM alpine:latest

LABEL maintainer="lapicidae"

ENV TZ="Europe/Berlin"

# copy local files
COPY root/ /

RUN echo "**** install runtime packages ****" && \
    echo "@testing https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk add --no-cache --upgrade \
      bash \
      coreutils \
      curl \
      grep \
      tzdata && \
    apk add --no-cache rsstail@testing && \
    echo "*********** set timezone *********" && \
    ln -s /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ >/etc/timezone && \
    echo "********* set permissions ********" && \
    chmod 755 /usr/bin/docker-entrypoint.sh && \
    echo "************ link files **********" && \
    ln -s /usr/bin/docker-entrypoint.sh /docker-entrypoint.sh && \
    echo "************ init cron ***********" && \
    crontab /defaults/fa-cron && \
    echo "************* cleanup ************" && \
    rm -rf /var/cache/apk/*

VOLUME ["/config"]

ENTRYPOINT ["/docker-entrypoint.sh"]
