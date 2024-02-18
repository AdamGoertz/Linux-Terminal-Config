#!/usr/bin/env bash
wget -nc https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip -O /tmp/FiraCode.zip
mkdir -p ~/.fonts/FiraCode
unzip -n /tmp/FiraCode.zip -d ~/.fonts/FiraCode 
fc-cache -fE ~/.fonts

success=$(fc-list | grep -q FiraCode)

if [[ $success -eq 0 ]]; then
    printf "\n\nFiraCode font installed. You will need to set your terminal font manually.\n\n"
fi

exit $success 
