FROM node:4.2-slim

RUN groupadd user && useradd --create-home --home-dir /home/user -g user user

ENV REACT_SOURCE /usr/src/react

WORKDIR $REACT_SOURCE

COPY config.js /config.js

RUN set -x \
    && apt-get update \
    && apt-get install -y git \
    && rm -rf /var/lib/apt/lists/*
RUN buildDeps=' \
    gcc \
    make \
    python \
    ' \
    && set -x \
    && apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
    && git clone https://github.com/twreporter/twreporter-react.git \
    && cd twreporter-react \
    && git checkout revamp \
    && git pull \
    && cp /config.js ./api/ \
    && cp -rf . .. \
    && cd .. \
    && rm -rf twreporter-react \
    && npm install \
    && npm install forever \
    && npm run build

EXPOSE 3000
CMD ["npm", "start"]
