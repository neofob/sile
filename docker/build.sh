#!/bin/bash
# Loosely based on .travis scripts
set -e

SILE_COMMIT=${SILE_COMMIT:=master}
GIT_URL=${GIT_URL:=https://github.com/simoncozens/sile.git}

git clone --depth=10 -b $SILE_COMMIT $GIT_URL sile
cd sile

export LUAROCKS=2.4.2
export HARFBUZZ_BASE=harfbuzz-1.7.1
export GRAPHITE=true
export COVERAGE=false
export LUA=lua5.3
export COVERAGE=true
export TRAVIS_BUILD_DIR=/tmp
rm -fr /root/.lua
source ./travis/setenv_lua.sh

mkdir ~/.fonts

export LD_LIBRARY_PATH=$HOME/local/lib:$LD_LIBRARY_PATH
export LIBRARY_PATH=$HOME/local/lib:$LD_LIBRARY_PATH
export LD_RUN_PATH=$HOME/local/lib:$LD_RUN_PATH
export PKG_CONFIG_PATH=$HOME/local/lib/pkgconfig:$PKG_CONFIG_PATH
if [ ! -f ~/.fonts/NotoSansMalayalam-Regular.ttf ]; then       pushd ~/.fonts/ ;       wget http://dealer.simon-cozens.org/~simon/tmp/silefonts.tar.gz ;       tar xvf silefonts.tar.gz ;       popd ;    fi

if [ ! -f ~/local/include/harfbuzz/hb.h ]; then       mkdir ~/local/ || true;       mkdir ~/builddeps / || true;       pushd ~/builddeps/ ;       wget http://www.freedesktop.org/software/harfbuzz/release/$HARFBUZZ_BASE.tar.bz2 ;       tar xfj $HARFBUZZ_BASE.tar.bz2 ;       cd $HARFBUZZ_BASE ;       ./configure --with$($GRAPHITE || echo 'out')-graphite2 --prefix=$HOME/local/ ;       make ;       make install ;       popd ;    fi
export LUA_HOME_DIR=$TRAVIS_BUILD_DIR/install/lua
export LUA=~/.lua/lua
export LUA_INCLUDE=-I$LUA_HOME_DIR/include
export LD_LIBRARY_PATH=$LUA_HOME_DIR/lib:$LD_LIBRARY_PATH
export LIBRARY_PATH=$LUA_HOME_DIR/lib:$LD_LIBRARY_PATH
export LD_RUN_PATH=$LUA_HOME_DIR/lib:$LD_RUN_PATH
export PATH=.travis:$PATH
luarocks install lpeg lua-zlib
luarocks install lpeg
luarocks install lua-zlib
luarocks install luaexpat
luarocks install luafilesystem
luarocks install lua_cliargs 2.3-3
luarocks install busted
luarocks install luacov 0.8-1
luarocks install luacov-coveralls
./bootstrap.sh
./configure && make

busted --cpath="core/?.so" -m './lua-libraries/?.lua;./lua-libraries/?/init.lua' tests
make tests
make docs
make install

