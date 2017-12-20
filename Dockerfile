FROM alpine:3.7

RUN apk add --no-cache \
      docker \
      python

RUN apk add --no-cache --virtual .build-dependencies \
      py-pip \
 && pip install awscli \
 && apk --purge del \
      .build-dependencies

COPY entrypoint.sh /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
