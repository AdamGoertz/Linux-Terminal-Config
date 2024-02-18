#!/usr/bin/env bash

sudo apt-get update && sudo apt-get install tmux xclip
mkdir -p ~/.tmux/plugins
git clone --branch v3.1.0 --single-branch https://github.com/tmux-plugins/tpm.git ~/.tmux/plugins/tpm

