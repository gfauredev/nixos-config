# NO_BROWSER=true
# GEMINI_SANDBOX_IMAGE=gemini-sandbox
SANDBOX_SET_UID_GID=true
SANDBOX_FLAGS="\
  --security-opt label=disable \
  --volume /nix:/nix:O \
  --volume /etc/nix:/etc/nix:O \
  --volume /etc/ssl/certs:/etc/ssl/certs:ro \
  --volume /etc/static/ssl:/etc/static/ssl:ro \
  --tmpfs /tmp \
  --env PATH=\"$(dirname $(readlink -f $(which nix)))\":/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \ 
"
  # -v /run/current-system/sw:/run/current-system/sw:ro \
  # -w /workspace \
  # -e PATH=\"$PATH:/run/current-system/sw/bin\" \
  # -v \"$HOME/.gemini:/workspace/.gemini:rw\" \
  # -v \"$PWD:/workspace:rw\" \
  # --userns=keep-id \
  # --volume /nix:/nix:ro \
  # --volume /nix/store:/nix/store:ro \
  # -v /nix/var/nix/daemon-socket/socket:/nix/var/nix/daemon-socket/socket:ro \
  # -e HOME=/workspace \
  # -e HOME=/home/node \
