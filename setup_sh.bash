#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
OLD_CONFIG_DIR="old_configs"
CURRENT_CONFIG_DIR="configs"
DATETIME=$(date +%F__%H_%M_%S)

shopt -s dotglob

sudo apt update && sudo apt install -y tmux xclip vim xterm x11-xserver-utils

mkdir -p $SCRIPT_DIR/$OLD_CONFIG_DIR/$DATETIME

# TODO: Add config directories like .vim

for FILE in $CURRENT_CONFIG_DIR/*; do
        [ -e "$FILE" ] || continue
        FILE_BASE=$(basename $FILE)
        echo "Updating: $FILE_BASE..."
        FILE_HOME="~/$FILE_BASE"

        if [ -L $FILE_HOME ]; then
                rm $FILE_HOME
        fi

        if [ -e $FILE_HOME ]; then
                mv $FILE_HOME $SCRIPT_DIR/$OLD_CONFIG_DIR/$DATETIME
        fi

        ln -s $SCRIPT_DIR/$CURRENT_CONFIG_DIR/$FILE ~
done

xrdb -merge ~/.Xresources

