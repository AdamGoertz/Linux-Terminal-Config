#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BIN_DIR=$SCRIPT_DIR/../bin

NEOVIM_INSTALLED=$(apt list --installed | grep neovim | wc -l)

INSTALL_DIR=~/.neovim
NVIM_BIN=nvim-linux64.deb

if [[ $FORCE_INSTALL_NVIM == "1" ]]; then
  rm -rf $INSTALL_DIR
  rm $BIN_DIR/$NVIM_BIN
fi

if [[ $NEOVIM_INSTALLED -lt 1 ]] || [[ $FORCE_INSTALL_NVIM == "1" ]]; then
    sudo apt-get update 
    sudo apt-get install -y cmake gettext ripgrep fd-find unzip python3-venv

    if [[ ! -f $BIN_DIR/nvim-linux64.deb ]]; then
      git clone --branch v0.10.1 --single-branch https://github.com/neovim/neovim.git $INSTALL_DIR
      cd $INSTALL_DIR
      cmake -S cmake.deps -B .deps -D CMAKE_BUILD_TYPE=Release
      cmake --build .deps
      cmake -B build -D CMAKE_BUILD_TYPE=Release
      cmake --build build -j$(nproc)
      cd build && cpack -G DEB
      mkdir -p $BIN_DIR
      cp $NVIM_BIN $BIN_DIR
    fi
    sudo dpkg -i --force-overwrite $BIN_DIR/$NVIM_BIN
else
    echo "Neovim installation found. Using existing installation"
fi
