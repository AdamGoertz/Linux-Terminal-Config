#!/usr/bin/env bash

sudo apt-get update && sudo apt-get install -y cmake gettext ripgrep unzip python3-venv

NEOVIM_INSTALLED=$(apt list --installed | grep nvim | wc -l)

if [[ $NEOVIM_INSTALLED -lt 1 ]] || [[ $FORCE_INSTALL_NVIM == "1" ]]; then
    git clone --branch v0.9.5 --single-branch https://github.com/neovim/neovim.git ~/.neovim
    cd ~/.neovim
    cmake -S cmake.deps -B .deps -D CMAKE_BUILD_TYPE=Release
    cmake --build .deps
    cmake -B build -D CMAKE_BUILD_TYPE=Release
    cmake --build build -j$(nproc)
    cd build && cpack -G DEB && sudo dpkg -i --force-overwrite nvim-linux64.deb
else
    echo "Neovim installation found. Using existing installation"
fi
