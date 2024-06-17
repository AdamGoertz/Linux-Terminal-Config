#!/usr/bin/env bash

sudo apt-get install -y automake flex texi2html texinfo libreadline6-dev
wget -nc https://github.com/cgdb/cgdb/archive/refs/tags/v0.8.0.tar.gz -O /tmp/cgdb-0.8.0.tar.gz
tar xzkf /tmp/cgdb-0.8.0.tar.gz -C /tmp &> /dev/null
cd /tmp/cgdb-0.8.0/
./autogen.sh
./configure --prefix=$HOME/.local
make -j$(nproc)
sudo make install -j$(nproc)
