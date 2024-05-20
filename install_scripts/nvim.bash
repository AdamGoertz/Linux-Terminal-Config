#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BIN_DIR=$SCRIPT_DIR/../bin/

NEOVIM_INSTALLED=$(apt list --installed | grep neovim | wc -l)

if [[ $NEOVIM_INSTALLED -lt 1 ]] || [[ $FORCE_INSTALL_NVIM == "1" ]]; then
    sudo apt-get update && sudo apt-get install -y cmake gettext ripgrep unzip python3-venv

    if [[ ! -f $BIN_DIR/nvim-linux64.deb ]]; then
      git clone --branch v0.9.5 --single-branch https://github.com/neovim/neovim.git ~/.neovim
      cd ~/.neovim
      cmake -S cmake.deps -B .deps -D CMAKE_BUILD_TYPE=Release
      cmake --build .deps
      cmake -B build -D CMAKE_BUILD_TYPE=Release
      cmake --build build -j$(nproc)
      cd build && cpack -G DEB
      mkdir -p $BIN_DIR
      cp nvim-linux64.deb $BIN_DIR
    fi
    sudo dpkg -i --force-overwrite $BIN_DIR/nvim-linux64.deb
else
    echo "Neovim installation found. Using existing installation"
fi
