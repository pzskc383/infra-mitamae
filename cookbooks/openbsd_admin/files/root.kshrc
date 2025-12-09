. /etc/ksh.kshrc

HISTFILE=$HOME/.ksh_history
HISTSIZE=1000000

# PS1='\u@\h \W \e[$(($??31:0))m\$\e[0m '

PS1=''
if [ "$(id -u)" -ne 1000 ]; then
    PS1='$( id -un )@'
fi
if ! [ -z "$SSH_CLIENT" ]; then
    PS1="$PS1"'$( expr $(hostname) : "\([^.]*\)" )'
fi

PS1="${PS1+$PS1 }"\
'$( X="$PWD/"; Y="$HOME/"; '\
'   [ "${X#$Y}" = "$PWD/" ] && echo "$PWD" || echo "~${PWD#$HOME}" ) '\
'\\[$( printf "\\033[%dm" "$(($? ? 31 : 0))" )\\]'\
'$( [ $(id -u) -eq 0 ] && echo "#" || echo "$" )'\
'\\[$( printf "\\033[0m" )\\]'\
' '

export PS1

alias ll='ls -l'
alias la='ls -la'
alias L='less'