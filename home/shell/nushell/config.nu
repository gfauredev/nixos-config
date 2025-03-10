# System config
def --wrapped cfg [...arg] { # Configure NixOS and Home Manager
  cd $env.CONFIG_FLAKE
  # direnv exec .
  configure ...$arg
}

# Mount usb and Android devices easily
def --env --wrapped usb [...arg] { # USB removable devices
  cd ~; # Preventively change directory to home in case of unmount
  mount-usb ...$arg
  try {
    cd ~/usb # Change to the mount directory, will fail if it was an unmount
  } catch {cd -}
}
def --env --wrapped mtp [...arg] { # Android devices over USB
  cd ~; # Preventively change directory to home in case of unmount
  mount-mtp ...$arg
  try {
    cd ~/mtp # Change to the mount directory, will fail if it was an unmount
  } catch {cd -}
}

# List
def sl [] {ls | reverse}
def lsd [] {ls | sort-by modified}
def sld [] {ls | sort-by modified | reverse}
def al [] {ls --all --long | reverse}

# Create a directory and cd into it
# TODO if multiple directories, open terms inside them
def --env md [newWorkingDir] {mkdir -v ($newWorkingDir); cd ($newWorkingDir)}

# Git
def upsub [] {git commit -am 'build: update submodule(s)'; git push}
def pupu [] {git pull --recurse-submodules --jobs=8; git push}

# Clear screen and display contextual status if empty command line
$env.config.hooks.pre_execution = (
  $env.config.hooks.pre_execution?
  | default []
  | append {
    if (commandline | is-empty) {
      clear --keep-scrollback
      if (date now) - (who -H|from ssv|get TIME|first|into datetime) < 5min {
        fastfetch
      }
      print (ls | table)
      if (git status | complete | $in.exit_code == 0) {
        git status
      } else {
        date now
      }
    }
  }
)

$env.config.hooks.command_not_found = {
  |command_name| print (command-not-found $command_name | str trim)
}
