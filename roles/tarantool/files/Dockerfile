FROM tarantool/tarantool:2

RUN apk add build-base lua5.1-dev

RUN git clone https://github.com/yangxikun/opentelemetry-lua /opentelemetry-lua

WORKDIR /opentelemetry-lua

RUN luarocks make

WORKDIR /opt/tarantool
