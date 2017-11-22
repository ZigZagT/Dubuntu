#!/usr/bin/env zsh
# load bashrc
alias shopt="echo unsupported bash command: shopt "
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

export ZSH=/root/.oh-my-zsh
export EDITOR=vim
ZSH_THEME="dubuntu"
plugins=(git git_remote_branch encode64 sudo docker docker-compose command-not-found debian systemd common-aliases dirhistory jsontools pip python screen urltools)
source $ZSH/oh-my-zsh.sh

alias ls='ls -pGC'
alias dc='docker-compose'
alias count-cpp="git ls-files | grep -E '(\.cpp)|(\.h)$' | xargs wc -l"
alias count-c="git ls-files | grep -E '(\.c)|(\.h)$' | xargs wc -l"
alias ipt='iptables'
alias drd='docker rmi $(docker images -q -f dangling=true)'
ipl() {
    local stack=""
    iptables -L --line-numbers -nv $@ | while read line; do
        if [ ! "$(echo $line | awk '{ print $1 }')" = "Chain" ]; then
            stack="$stack\n$line"
        else
            if [ -n $stack ]; then
                print $stack | column -t
                stack=""
            fi
            echo $line
        fi
    done
    if [ -n $stack ]; then
        print $stack # | column -t
    fi
}

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

source /root/.dircolors_source
if [ -f /shared/profile ]; then source /shared/profile; fi
