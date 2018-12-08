FROM ubuntu:xenial as builder
LABEL maintainer "tuan t. pham <tuan@vt.edu>"

# master/branch..etc.
# ARG SILE_COMMIT
# ARG GIT_URL
# ENV GIT_URL=https://github.com/simoncozens/sile.git

# Done
ENV DEBIAN_FRONTEND=noninteractive \
    PKGS="git pkg-config libgraphite2-dev libicu-dev libreadline-dev \
    libfreetype6-dev libfontconfig1-dev libpng-dev libexpat1-dev \
    libipc-run-perl unzip autoconf libtool"

RUN apt-get update -yq && apt-get upgrade -yq && \
    apt-get install -yq ${PKGS}

COPY ./build.sh /tmp
WORKDIR /tmp
RUN build.sh

ENV LUAROCKS=2.4.2 \
    HARFBUZZ_BASE=harfbuzz-1.7.1 \
    GRAPHITE=true \
    COVERAGE=false \
    LUA=lua5.3 \
    COVERAGE=true


FROM ubuntu:xenial
LABEL maintainer "tuan t. pham <tuan@vt.edu>"
ENV DEBIAN_FRONTEND=noninteractive

COPY --from=builder /usr/local/share/sile /usr/local/share/
COPY --from=builder /usr/local/bin/sile /usr/local/bin/
COPY --from=builder /usr/local/lib/* /usr/local/lib/
COPY --from=builder /tmp/install/lua /usr/local/
COPY --from=builder /tmp/install/luarocks /usr/local/
