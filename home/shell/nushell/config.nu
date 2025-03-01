# See https://www.nushell.sh/book/getting_started.html
    
# List
def sl [] {ls | reverse}
def lsd [] {ls | sort-by modified}
def sld [] {ls | sort-by modified | reverse}
def al [] {ls --all --long | reverse}

# TODO equivalent that created a directory and cd into it
# mkdir -pv "$@" && cd "$1" || return

# Git
def upsub [] {git commit -am 'build: update submodule(s)'; git push}
def pupu [] {git pull --recurse-submodules --jobs=8; git push}

$env.config.show_banner = false
