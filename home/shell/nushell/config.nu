# System config
def --wrapped cfg [...rest: string] { # Configure NixOS and Home Manager
  cd $env.CONFIG_FLAKE; configure ...$rest; cd -
}

# Mount usb and Android devices easily
def --wrapped usb [...rest: string] { # USB removable devices
  cd $env.CONFIG_FLAKE; mount-usb ...$rest; cd -
}
def --wrapped mtp [...rest: string] { # Android devices over USB
  cd $env.CONFIG_FLAKE; mount-mtp ...$rest; cd -
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
      print (ls | table)
      if (git status | complete | $in.exit_code == 0) {
        git status
      } else {
        date now
      }
      # TODO display hello message if session time less than 5 min (300s)
      # if (w -h -s|head -n1|tr -s ' '|cut -d' ' -f3|into datetime) {
      # }
    }
  }
)

$env.config.hooks.command_not_found = {
  |command_name| print (command-not-found $command_name | str trim)
}
