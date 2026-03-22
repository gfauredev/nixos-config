# NIX_REMOTE="daemon"
# NIX_CONFIG="accept-flake-config = true"
# NO_BROWSER=true
GEMINI_SANDBOX_IMAGE=gemini-sandbox
SANDBOX_SET_UID_GID=true
SANDBOX_FLAGS="--volume /nix/store:/nix/store:O --volume /nix/var/nix/daemon-socket/socket:/nix/var/nix/daemon-socket/socket:rw --volume /etc/nix/nix.conf:/etc/nix/nix.conf:ro --volume /etc/ssl/certs:/etc/ssl/certs:ro --volume /etc/static/ssl:/etc/static/ssl:ro --volume /run/current-system/sw/bin:/run/current-system/sw/bin:ro --volume /home/gf/.cargo:/home/node/.cargo:O --volume /home/gf/.android:/home/node/.android:O --env PATH --env NIX_REMOTE --env NIX_CONFIG"
# TODO Variabilise home dir, use it for .cargo , .android…
# --security-opt label=disable
# --userns=keep-id
# --workdir /workspace
# --tmpfs /tmp
# --tmpfs /nix/var/nix:rw,exec,mode=1777
# --volume /nix:/nix:O
# --volume /nix/var/nix/db:/nix/var/nix/db:O
# --volume /nix/var/nix/profiles:/nix/var/nix/profiles:O
# --volume /nix/var/nix/temproots:/nix/var/nix/temproots:O
# --volume /nix/var/nix/gcroots:/nix/var/nix/gcroots:O
# --volume /etc/nix:/etc/nix:O
# --volume /etc/ssl/certs:/etc/ssl/certs:ro
# --volume /etc/static/ssl:/etc/static/ssl:ro
# --volume /run/current-system/sw:/run/current-system/sw:ro
# --volume $HOME/.gemini:/workspace/.gemini:rw
# --volume $PWD:/workspace:rw
