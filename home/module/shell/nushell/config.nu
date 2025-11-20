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
      | first | get mode | str contains "x") {
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

# Edit project’s of life’s code
def --env code [] {
    let CODE_DIR = "code"
    print --no-newline $"Code directory: ($CODE_DIR), "
    let MIRROR_DIRS = [ project life ] 
    print $"Directories of which to mirror the hierarchy: ($MIRROR_DIRS)"
    mut dest = ($nu.home-path | path join $CODE_DIR) # Dir to change to
    try { # Below line can fail if not under ~
      let _WD_REL_TO_HOME = pwd | path relative-to $nu.home-path | path split
      let HOME_CHILD = $_WD_REL_TO_HOME.0 # Direct home child we’re under…
      let HIERARCHY = $_WD_REL_TO_HOME | slice 1.. | path join # Rest
      print --no-newline $"Hierarchy ($HIERARCHY) of ~/($HOME_CHILD): "
      if $HOME_CHILD in $MIRROR_DIRS { # Could be factorized with below
        $dest = $nu.home-path | path join $CODE_DIR | path join $HIERARCHY
        if ($dest | path type) == dir {
          print $"changing to correspondant ($CODE_DIR) subdir: ($dest)"
        } else if not ($dest | path exists) {
          print $"replicating dir hierarchy into ($CODE_DIR)"
          mkdir --verbose $dest # Mirror dir hierarchy under ~/code if needed
        } else {
          print $"cannot change into ($dest) nor create a same named directory"
        }
      } else if $HOME_CHILD == $CODE_DIR { # Could be factorized with above
        for mirror_dir in $MIRROR_DIRS {
          $dest = $nu.home-path | path join $mirror_dir | path join $HIERARCHY
          if ($dest | path type) == dir {
            print $"changing to correspondant ($MIRROR_DIRS) subdir: ($dest)"
          } else if not ($dest | path exists) {
            print $"replicating dir hierarchy into ($MIRROR_DIRS)"
            mkdir --verbose $dest
          } else {
            print $"cannot change into ($dest) nor create a same named directory"
          }
          break # Prevent for loop from mirorring hierarchy everywhere
        }
      } else {
        print $"not under ($MIRROR_DIRS | append $CODE_DIR), just go to ($dest)"
      }
    } # end try
    cd $dest
}

# Edit system and home config
def --wrapped cfg [...arg] { # Configure NixOS and Home Manager
  cd $env.CONFIG_LOCATION
  # direnv exec . # FIXME doesn’t seems to use direnv properly inside editor, LSPs not worky
  systemd-inhibit --what=shutdown:sleep --who=cfg --why=Configuring configure ...$arg
}

# Open in background with default app
def start-bg [file] {
  job spawn {start $file}
  # task spawn --immediate {start $file}
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
let carapace_completer = {|spans|
    carapace $spans.0 nushell ...$spans | from json
}
let zoxide_completer = {|spans|
    $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
}
# let fish_completer = {|spans|
#     fish --command $'complete "--do-complete=($spans | str join " ")"'
#     | from tsv --flexible --noheaders --no-infer
#     | rename value description
# }
let external_completer = {|spans|
    let expanded_alias = scope aliases
    | where name == $spans.0
    | get --ignore-errors 0.expansion # --optional 0.expansion
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
        _ => $carapace_completer # Defaults to carapace for completions
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
