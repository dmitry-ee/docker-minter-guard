### BASE IMAGE ###
FROM    python:3.6-alpine as base
FROM    base              as builder

WORKDIR /root
COPY    requirements.txt /root

RUN     set -ex && \
        apk add gcc git musl-dev && \
        pip install --no-cache-dir -r requirements.txt --user

### IMAGE ###
FROM    base

ARG     APP_DIR=/minter-guard
WORKDIR ${APP_DIR}

RUN     set -ex && \
        apk add bash

COPY    --from=builder /root/.local /usr/local

ENV     API_URL=http://127.0.0.1:8841/
ENV     PUB_KEY=Mpxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
ENV     SET_OFF_TX=XXXXXX
ENV     MISSED_BLOCKS=2
ENV     LOG_LEVEL=INFO
ENV     SLEEP_TIME_MS=1000

COPY    docker-entrypoint.sh ${APP_DIR}
COPY    config ${APP_DIR}

RUN     chmod +x docker-entrypoint.sh
ENV     PATH=.:$PATH

ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD        [ "start" ]
