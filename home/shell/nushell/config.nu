# Clear screen and display contextual status if empty command line
$env.config.hooks.pre_execution = (
  $env.config.hooks.pre_execution?
  | default []
  | append {
    if (commandline | is-empty) {
      clear --keep-scrollback
      if (date now) - (who -H|from ssv|get TIME|first|into datetime) < 2min {
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

# System config
def --wrapped cfg [...arg] { # Configure NixOS and Home Manager
  cd $env.CONFIG_FLAKE
  # direnv exec .
  configure ...$arg
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

$env.config.hooks.command_not_found = {
  |command_name| print (command-not-found $command_name | str trim)
}

# See https://www.nushell.sh/cookbook/external_completers.html#err-unknown-shorthand-flag-using-carapace
let fish_completer = {|spans|
    fish --command $'complete "--do-complete=($spans | str join " ")"'
    | from tsv --flexible --noheaders --no-infer
    | rename value description
}
let zoxide_completer = {|spans|
    $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
}
let external_completer = {|spans|
    let expanded_alias = scope aliases
    | where name == $spans.0
    | get -i 0.expansion
    let spans = if $expanded_alias != null {
        $spans
        | skip 1
        | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }
    match $spans.0 {
        # use zoxide completions for zoxide commands
        __zoxide_z | __zoxide_zi => $zoxide_completer
        _ => $fish_completer
    } | do $in $spans
}

$env.config.completions.external = {
  enable: true
  completer: $external_completer
}
