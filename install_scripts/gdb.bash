#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source $SCRIPT_DIR/utils.bash

if command_version_ge gdb "14" ; then
    echo "gdb 14+ already installed"
    exit 0
fi

if ! command_version_ge python3 "3.5" ; then
    echo "python3 >= 3.5 required."
    exit 1
fi

sudo apt install -y libgmp-dev libmpfr-dev

wget -nc -O /tmp/gdb-14.1.tar.gz https://ftp.gnu.org/gnu/gdb/gdb-14.1.tar.gz
tar xzkf /tmp/gdb-14.1.tar.gz -C /tmp &> /dev/null
cd /tmp/gdb-14.1
./configure --prefix=$HOME/.local --with-python=$(which python3)
make -j$(nproc)
make install

