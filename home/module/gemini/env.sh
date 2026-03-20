# NO_BROWSER=true
# GEMINI_SANDBOX_IMAGE=gemini-sandbox
SANDBOX_SET_UID_GID=true
SANDBOX_FLAGS="--volume /nix/store:/nix/store:O --volume /nix/var/nix/daemon-socket/socket:/nix/var/nix/daemon-socket/socket:rw --env NIX_REMOTE=daemon --volume /etc/nix/nix.conf:/etc/nix/nix.conf:ro --volume /etc/ssl/certs:/etc/ssl/certs:ro --volume /etc/static/ssl:/etc/static/ssl:ro --volume /run/current-system/sw/bin:/run/current-system/sw/bin:ro --env PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/share/npm-global/bin:/run/current-system/sw/bin --env NIX_CONFIG=accept-flake-config=true"
# --security-opt label=disable
# --volume /nix:/nix:O
# --volume /nix/var/nix/db:/nix/var/nix/db:O
# --volume /nix/var/nix/profiles:/nix/var/nix/profiles:O
# --volume /nix/var/nix/temproots:/nix/var/nix/temproots:O
# --volume /nix/var/nix/gcroots:/nix/var/nix/gcroots:O
#  --tmpfs /nix/var/nix:rw,exec,mode=1777
# --volume /nix/var/nix/daemon-socket/socket:/nix/var/nix/daemon-socket/socket:ro
# --volume /etc/nix:/etc/nix:O
# --volume /etc/ssl/certs:/etc/ssl/certs:ro
# --volume /etc/static/ssl:/etc/static/ssl:ro
# --volume /run/current-system/sw:/run/current-system/sw:ro
# --volume $HOME/.gemini:/workspace/.gemini:rw
# --volume $PWD:/workspace:rw
# --userns=keep-id
# --workdir /workspace
# --tmpfs /tmp
# --env HOME=/workspace
# --env HOME=/home/node
# --env PATH=$PATH:/run/current-system/sw/bin
# --env PATH="$(dirname $(readlink -f $(which nix)))":/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
