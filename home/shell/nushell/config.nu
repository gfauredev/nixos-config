# See https://www.nushell.sh/book/getting_started.html
    
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
# TODO git status if in a git repository
# TODO display battery info in on a laptop
# TODO display ethernet info if connected over ethernet,
# if not, display wifi info if connected over wifi
# TODO display connected bluetooth devices info
# TODO display hello message if session time less than 5 min (300s)
def CR [] {
  if (commandline) == '' {
    clear --keep-scrollback
    commandline edit "ls" # Executed by the Enter
    # ls
  } # Let the enter event pass
}

$env.config.keybindings = [
  {
    # See https://www.nushell.sh/book/line_editor.html#send-type
    name: empty_cr
    modifier: none
    keycode: Enter
    mode: [emacs, vi_insert]
    event: [
      { send: ExecuteHostCommand,
        cmd: "CR" }
      { send: Enter }
    ]
  }
]

# $env.config.always_trash = true

$env.config.show_banner = false
