#!/usr/bin/env bash

sudo apt install cmake gettext
git clone --branch v0.9.5 --single-branch https://github.com/neovim/neovim.git ~/.neovim
cd ~/.neovim
cmake -S cmake.deps -B .deps -D CMAKE_BUILD_TYPE=Release
cmake --build .deps
cmake -B build -D CMAKE_BUILD_TYPE=Release
cmake --build build
cd build && cpack -G DEB && sudo dpkg -i --force-overwrite nvim-linux64.deb
