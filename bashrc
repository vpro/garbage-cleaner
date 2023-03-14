# \[..\]: instruct bash that this does not take up any space (they are ANSI control characters)
PS1="\[\033[7;1;36m\]\h|${POD_NAMESPACE##*-}-CLEANER:\[\033[0;1;34m\]\w\[\033[00m\]\$ "
#PS1="\h|${POD_NAMESPACE##*-}-CLEANER:\w\$ "
alias cl="cd /data/logs"
export LS_OPTIONS='--color=auto'
alias ls='ls $LS_OPTIONS'
alias rm='rm -i'


# See https://askubuntu.com/questions/67283/is-it-possible-to-make-writing-to-bash-history-immediate
shopt -s histappend
export PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
