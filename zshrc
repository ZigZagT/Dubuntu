#!/usr/bin/env zsh
source /root/.dircolors_source
export ZSH=/root/.oh-my-zsh
export EDITOR=vim
ZSH_THEME="dubuntu"
plugins=(git git_remote_branch encode64 sudo docker docker-compose command-not-found debian systemd common-aliases dirhistory jsontools pip python screen urltools)
source $ZSH/oh-my-zsh.sh

alias dc='docker-compose'
alias drd='docker rmi $(docker images -q -f dangling=true)'

# Fix numeric keypad
# 0 . Enter
bindkey -s "^[Op" "0"
bindkey -s "^[On" "."
bindkey -s "^[OM" "^M"
# 1 2 3
bindkey -s "^[Oq" "1"
bindkey -s "^[Or" "2"
bindkey -s "^[Os" "3"
# 4 5 6
bindkey -s "^[Ot" "4"
bindkey -s "^[Ou" "5"
bindkey -s "^[Ov" "6"
# 7 8 9
bindkey -s "^[Ow" "7"
bindkey -s "^[Ox" "8"
bindkey -s "^[Oy" "9"
# + -  * /
bindkey -s "^[Ol" "+"
bindkey -s "^[Om" "-"
bindkey -s "^[Oj" "*"
bindkey -s "^[Oo" "/"

if [ -f /shared/profile ]; then source /shared/profile; fi
