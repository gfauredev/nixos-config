# Mount Android
[ -d $HOME/mtp ] || mkdir $HOME/mtp
jmtpfs $HOME/mtp
# cd $HOME/mtp/ || return # TODO per shell function that does this
