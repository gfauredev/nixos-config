# TODO execute post-activation
dir=$(realpath "$(dirname "$0")")
ln --force --symbolic "$dir"/config "$XDG_CONFIG_HOME"/albert/config
ln --force --symbolic "$dir"/websearch "$XDG_CONFIG_HOME"/albert/websearch
