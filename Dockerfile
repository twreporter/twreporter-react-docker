FROM node:6.3-slim

RUN groupadd user && useradd --create-home --home-dir /home/user -g user user

ENV REACT_SOURCE /usr/src/react

WORKDIR $REACT_SOURCE

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
    && apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* 

# Provides cached layer for node_modules
ADD twreporter-react/package.json /tmp
RUN cd /tmp && npm install
RUN cp -a /tmp/node_modules $REACT_SOURCE/

# Add source files
ADD . /tmp/
RUN cp -a /tmp/twreporter-react/. $REACT_SOURCE/

RUN cd $REACT_SOURCE && npm run build

EXPOSE 3000
CMD ["npm", "start"]
