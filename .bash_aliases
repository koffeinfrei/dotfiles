# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alhF'
alias la='ls -A'
alias l='ls -CF'

alias less='less -R -i'

alias ai='sudo aptitude install'
alias as='sudo aptitude search'
function asi() { ai $(as "$@" | selecta | awk '{print $2}') ; }

# git aliases
function gitcc() { git clone "$@" && cd `ls -t | head -1`; }
alias git..='cd $(git rev-parse --show-toplevel || echo ".")'

# force colors in tmux
alias tmux='tmux -2'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

function psgrep() { ps auxf | grep -v grep | grep "$@" -i --color=auto; }

function netgrep() { netstat -tulpn | ag "$@"; }

function nfind() { find . -iname "*$@*"; }

function search_history() { eval $(history | awk -F"  " '{print $2}' | sort -u | selecta); }

bind '"\e\C-r":"\C-a search_history -- \C-j"'

alias trm='trash-put'

alias be="bundle exec"

function meteo() { curl -4 "http://wttr.in/$(echo ${@:-zurich} | tr ' ' _)"; }

# `fuck` for `thefuck`
alias fuck='TF_CMD=$(TF_ALIAS=fuck PYTHONIOENCODING=utf-8 TF_SHELL_ALIASES=$(alias) thefuck $(fc -ln -1)) && eval $TF_CMD && history -s $TF_CMD'
