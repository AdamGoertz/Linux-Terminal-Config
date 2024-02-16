#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
OLD_CONFIG_DIR="old_configs"
CURRENT_CONFIG_DIR="configs"
DATETIME=$(date +%F__%H_%M_%S)

shopt -s dotglob

sudo apt update && sudo apt install -y tmux xclip vim xterm x11-xserver-utils

NEOVIM_INSTALLED=$(apt list --installed | grep nvim | wc -l)

if [[ $NEOVIM_INSTALLED -lt 1 ]] || [[ $FORCE_INSTALL_NVIM == "1" ]]; then
    $SCRIPT_DIR/install_scripts/nvim.bash
else
    echo "Neovim installation found. Using existing installation"
fi

mkdir -p $SCRIPT_DIR/$OLD_CONFIG_DIR/$DATETIME

# TODO: Add config directories like .vim

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

