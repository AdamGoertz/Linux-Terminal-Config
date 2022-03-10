#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
OLD_CONFIG_DIR="old_configs"
CURRENT_CONFIG_DIR="configs"
DATETIME=$(date +%F__%H_%M_%S)

shopt -s dotglob

sudo apt install -y tmux xclip vim xterm

mkdir -p $SCRIPT_DIR/$OLD_CONFIG_DIR/$DATETIME

# TODO: Add config directories like .vim

for FILE in $CURRENT_CONFIG_DIR/*; do
        [ -e "$FILE" ] || continue
        FILE_BASE=$(basename $FILE)
        echo "Updating: $FILE_BASE..."
        mv ~/$FILE_BASE $SCRIPT_DIR/$OLD_CONFIG_DIR/$DATETIME
        ln -s $SCRIPT_DIR/$FILE ~
done

xrdb -merge ~/.Xresources

