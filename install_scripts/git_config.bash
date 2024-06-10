#!/usr/bin/env bash

# Use this script ot set up git config rather than a file so that we can leave
# some config settings unchanged (such as user.email), which we might want to 
# set differently depending on the context (e.g. work or personal).

sudo apt-get update && sudo apt-get install git

wget -nc -O /tmp/difftastic-0.58.0.tar.gz https://github.com/Wilfred/difftastic/releases/download/0.58.0/difft-aarch64-unknown-linux-gnu.tar.gz 
tar xzkf /tmp/difftastic-0.58.0.tar.gz -C $HOME/.local/bin &> /dev/null

git config --global user.name "Adam Goertz"
git config --global alias.graph "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'"
git config --global alias.dlog "-c diff.external=difft log -p --ext-diff"
git config --global core.editor "vim"
git config --global diff.tool "difftastic"
git config --global difftool.prompt "false"
git config --global difftool difftastic.cmd "difft $LOCAL $REMOTE"
git config --global pager.difftool "true"

