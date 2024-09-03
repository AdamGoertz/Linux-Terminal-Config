#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
OLD_CONFIG_DIR="old_configs"
CURRENT_CONFIG_DIR="configs"
DATETIME=$(date +%F__%H_%M_%S)

shopt -s dotglob

sudo apt-get update && sudo apt-get install -y vim xterm

in_docker () {
    grep -q docker /proc/1/cgroup
}

if ! in_docker ; then
    sudo apt-get update && sudo apt-get install -y xclip x11-xserver-utils
else
    echo "Skipping X package installs inside docker"
fi

# Neovim
$SCRIPT_DIR/install_scripts/nvim.bash

# Git
$SCRIPT_DIR/install_scripts/git_config.bash

# Atuin
$SCRIPT_DIR/install_scripts/atuin.bash

# Fonts
if ! in_docker ; then
    $SCRIPT_DIR/install_scripts/fonts.bash
else
    echo "Skipping font install inside of docker"
fi

# tmux
if ! in_docker ; then
    $SCRIPT_DIR/install_scripts/tmux.bash
else
    echo "Skipping tmux install inside of docker"
fi

# gdb
$SCRIPT_DIR/install_scripts/gdb.bash

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

if ! in_docker ; then
    xrdb -merge ~/.Xresources
else
    echo "Skipping xrdb merge inside docker"
fi

ADD_LOCAL_BIN_PATH='export PATH=$HOME/.local/bin:$PATH'
grep -q -F "$ADD_LOCAL_BIN_PATH" "$HOME/.bashrc" || echo $ADD_LOCAL_BIN_PATH >> ~/.bashrc

if ! in_docker ; then
    echo "Reminder: use ctrl-A + I in tmux to install plugins."
fi
