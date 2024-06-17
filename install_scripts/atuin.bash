#!/usr/bin/env bash

echo 'export PATH=$HOME/.atuin/bin:$PATH' >> $HOME/.bashrc

bash <(curl https://raw.githubusercontent.com/atuinsh/atuin/main/install.sh)

atuin import auto
