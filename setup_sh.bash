SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

sudo apt install -y tmux xclip vim 

ln -s $SCRIPT_DIR/.tmux.conf $SCRIPT_DIR/.bash_aliases ~
