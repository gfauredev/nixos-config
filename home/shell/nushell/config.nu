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
# TODO display battery info in on a laptop
# TODO display ethernet info if connected over ethernet,
#   if not, display wifi info if connected over wifi
# TODO display connected bluetooth devices info
# Actually run ENTER on empty command line Enter
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
