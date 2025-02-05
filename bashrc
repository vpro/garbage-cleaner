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


# Show the uptime of the supercronic application
function aptime() {
    # moving the cursor at the beginning of line and then move it forward by 40 columns
    col="\033[50D\033[40C"
    if [ -e /root/pid ]; then
      pid=$(cat /root/pid)
      echo -e "pid:$col$pid"
      starttime=$(stat -c %y /root/pid)
      echo -e "starttime:$col$starttime"
      uptime=$(ps  -o pid,etime  | awk "\$1 == $pid {print \$2}")
      echo -e "uptime:$col$uptime"
    fi
    echo -e "supercronic version:$col${SUPERCRONIC_URL}"
    
    OS_VERSION=$(cat /etc/os-release | grep PRETTY_NAME | awk -F= "{print \$2}" | tr -d '"')
    echo -e "os version:$col${OS_VERSION}"
    cat /DOCKER.BUILD | awk -F= "{print \$1\":$col\"\$2}"
}