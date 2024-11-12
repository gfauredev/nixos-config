echo "Apply config NOT the Nix way"

ln --force --symbolic --verbose /config/home/wayland/launcher/albert/* \
  "$XDG_CONFIG_HOME/albert/"
