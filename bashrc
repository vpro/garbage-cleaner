export PS1="${debian_chroot:+($debian_chroot)}\u@\h|${POD_NAMESPACE##*-}-CLEANER:\w\$ "
alias cl="cd /data/logs"
export LS_OPTIONS='--color=auto'
alias ls='ls $LS_OPTIONS'
alias rm='rm -i'