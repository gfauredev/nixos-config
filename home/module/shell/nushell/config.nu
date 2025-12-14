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


# A command to toggle between source directories and a mirror directory
def --env mirror [
    mirror_root: path,          # The destination mirror root (eg. /dev/me)
    mirrored_roots: list<path>, # The source roots (eg. ["/home/me/project"])
    ...files: path              # Optional files to move to the destination
] {
  let wd_abs = (pwd --physical)
  let mirror_abs = ($mirror_root | path expand)
  let sources_abs = ($mirrored_roots | each { |it| $it | path expand })
  let move_files_to_dest = {|dest_path|
    if ($files | is-not-empty) {
      for file in $files {
        let file_abs = ($file | path expand)
        if ($file_abs | path exists) {
          print $"Moving ($file) to ($dest_path)"
          mv $file_abs $dest_path
        } else {
          print $"($file) (ansi yellow)not found(ansi reset), skipping"
        }
      }
    }
  }
  for source in $sources_abs {
    if ($wd_abs | str starts-with $source) {
      let target_path = (
        $mirror_abs | path join ($wd_abs | path relative-to $source)
      )
      if not ($target_path | path exists) {
        print $"($target_path) does not exist, creating it"
        mkdir $target_path
      }
      do $move_files_to_dest $target_path
      cd $target_path
      return
    }
  }
  if ($wd_abs | str starts-with $mirror_abs) {
    let relative_path = ($wd_abs | path relative-to $mirror_abs)
    for source in $sources_abs {
      let potential_target = ($source | path join $relative_path)
      if ($potential_target | path exists) {
        do $move_files_to_dest $potential_target
        cd $potential_target
        return
      }
    }
    print $"($relative_path) (ansi red)not found(ansi reset) in any of ($mirrored_roots)"
    return
  }
  print $"($wd_abs) (ansi red)not found(ansi reset) in any of ($mirrored_roots | append $mirror_root)"
}

def --env dev [...args: path] { # Quickly edit code related to project/life or dev env
  if not ($args | is-empty) {
    if not ($args.0 | path exists) { # An argument that’s not a file is certainly a stack 
      nix flake init --template $"~/dev/dev-templates#($args.0)" ...($args | skip 1)
      return
    }
  }
  mirror "~/dev" [ "~/project" "~/life" ] ...$args
}

# Edit system and home config
# def --wrapped cfg [...arg] { # Configure NixOS and Home Manager
#   cd $env.CONFIG_LOCATION
#   # direnv exec . # FIXME doesn’t seems to use direnv properly inside editor, LSPs not worky
#   systemd-inhibit --what=shutdown:sleep --who=cfg --why=Configuring configure ...$arg
# }

# Open in background with default app
def x [file] {
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
    | get --optional 0.expansion # --optional 0.expansion
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
