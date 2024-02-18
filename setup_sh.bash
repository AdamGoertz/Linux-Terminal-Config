#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
OLD_CONFIG_DIR="old_configs"
CURRENT_CONFIG_DIR="configs"
DATETIME=$(date +%F__%H_%M_%S)

shopt -s dotglob

sudo apt-get update && sudo apt-get install -y xclip vim xterm x11-xserver-utils

# Neovim
$SCRIPT_DIR/install_scripts/nvim.bash

# Fonts
$SCRIPT_DIR/install_scripts/fonts.bash

# tmux
$SCRIPT_DIR/install_scripts/tmux.bash

# Dotfiles
mkdir -p $SCRIPT_DIR/$OLD_CONFIG_DIR/$DATETIME

for FILE in $CURRENT_CONFIG_DIR/*; do
    FILE_BASE=$(basename $FILE)
    echo "Updating: $FILE_BASE..."
    FILE_HOME="$HOME/$FILE_BASE"
    echo "Checking state of $FILE_HOME"

    if [ -L "$FILE_HOME" ]; then
    echo "Removing existing symlink: $FILE_HOME"
            unlink $FILE_HOME
    fi

    if [ -e "$FILE_HOME" ]; then
    echo "Moving existing file: $FILE_HOME to $SCRIPT_DIR/$OLD_CONFIG_DIR/$DATETIME"
            mv $FILE_HOME $SCRIPT_DIR/$OLD_CONFIG_DIR/$DATETIME
    fi

	echo "Creating symlink: $SCRIPT_DIR/$FILE"
    ln -s $SCRIPT_DIR/$FILE ~
done

xrdb -merge ~/.Xresources

