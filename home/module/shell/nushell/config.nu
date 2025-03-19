$env.config.hooks.pre_execution = (
  $env.config.hooks.pre_execution?
  | default []
  | append [
    # Clear screen and display contextual status if empty command line
    {
    if (commandline | is-empty) {
      clear --keep-scrollback
      print (ls | table)
      if (git status | complete | $in.exit_code == 0) {
        git status
      } else {
        print (date now)
      }
    # Start with default handler if only a non executable file or a symlink
    } else if (commandline
      | path type) in [file symlink] and not (ls --long (commandline)
      | get mode | str contains "x") {
      start (commandline)
      # commandline edit ("start " + (commandline))
    # Open editor if path with a dot "/."
    } else if (commandline) == "." {
      run-external $env.EDITOR .
    } else if (commandline | str ends-with "/.") {
      run-external $env.EDITOR (commandline | str substring 0..-3)
      # commandline edit ($env.EDITOR + " " + (commandline|str substring 0..-3))
    }
    }
  ]
)

# Edit system and home config
def --wrapped cfg [...arg] { # Configure NixOS and Home Manager
  cd $env.CONFIG_FLAKE
  # direnv exec .
  configure ...$arg
}

# Open in background with default app
def x [target:string] {
  dash -c $"xdg-open ($target) &"
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
  if ($env.PWD | str downcase | str ends-with "usb") {
    cd ~; # Change directory to home to let ~/usb/ alone
  }
  mount.usb ...$arg # Mount or unmount USB device
  if ("~/usb" | path type) == "dir" {
    cd ~/usb # Change to the mount directory, will fail if it was an unmount
  }
}
def --env --wrapped mtp [...arg] { # Android devices over USB
  if ($env.PWD | str downcase | str ends-with "mtp") {
    cd ~; # Change directory to home to let ~/mtp/ alone
  }
  mount.mtp ...$arg # Mount or unmount Android device
  if ("~/mtp" | path type) == "dir" {
    cd ~/mtp # Change to the mount directory, will fail if it was an unmount
  }
}

# Additional completers
let zoxide_complete = {|spans|
    $spans | skip 1 | zoxide query -l ...$in | lines
    | where {|x| $x != $env.PWD}
}
let fish_complete = {|spans|
    fish --command $'complete "--do-complete=($spans | str join " ")"'
    | from tsv --flexible --noheaders --no-infer
    | rename value description
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
        # Zoxide completions for zoxide commands
        __zoxide_z | __zoxide_zi => $zoxide_complete
        # Fish completions by default
        _ => $fish_complete
    } | do $in $spans
}
$env.config.completions.external = {
  enable: true
  completer: $external_completer
}

# Display a welcome message for the first three minutes after login
if (date now) - (who -H|from ssv|get TIME|first|into datetime) < 3min {
  fastfetch
}
