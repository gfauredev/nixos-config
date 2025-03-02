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

$env.config.keybindings = [
  {
    # See https://www.nushell.sh/book/line_editor.html#send-type
    name: empty_cr
    modifier: none
    keycode: Enter
    mode: emacs
    event: {send: Enter} # TODO ctrl+l + ls + git status if line empty
  }
]

# $env.config.always_trash = true

$env.config.show_banner = false
