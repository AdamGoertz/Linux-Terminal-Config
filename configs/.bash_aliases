alias gs="git status"
alias gc="git commit"
alias gl="git log --stat"
alias ga="git add"
alias gd="git diff -w"
alias gb="git branch"
alias gch="git checkout"
alias gds="git diff --staged -w"

if command -v nvim > /dev/null ; then
    alias vim="nvim"
fi

git-changes () {
  git diff $(git log --author="$(git config --get user.name)" -1 --pretty=format:'%H')
}
