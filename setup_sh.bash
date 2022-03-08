SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
OLD_CONFIG_DIR="old_configs"
DATETIME=$(date +%F__%H_%M_%S)

sudo apt install -y tmux xclip vim 

mkdir -p $SCRIPT_DIR/$OLD_CONFIG_DIR/$DATETIME

mv ~/.tmux.conf $SCRIPT_DIR/$OLD_CONFIG_DIR/$DATETIME
mv ~/.bash_aliases $SCRIPT_DIR/$OLD_CONFIG_DIR/$DATETIME
mv ~/.vimrc $SCRIPT_DIR/$OLD_CONFIG_DIR/$DATETIME

ln -s $SCRIPT_DIR/.tmux.conf $SCRIPT_DIR/.bash_aliases $SCRIPT_DIR/.vimrc ~
