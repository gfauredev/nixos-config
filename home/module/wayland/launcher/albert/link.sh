# dir=$(realpath "$(dirname "$0")")
DIR=$XDG_CONFIG_HOME/albert
ln --force --symbolic $DIR/config.static $DIR/config
ln --force --symbolic $DIR/websearch.static $DIR/websearch
