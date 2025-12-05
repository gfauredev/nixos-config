{ config, ... }:
let
  common = {
    # System
    boot = "bootctl";
    reboot = "systemctl reboot";
    off = "systemctl poweroff";
    sys = "systemctl";
    jo = "journalctl -xfe";
    gc = "nix store gc";
    # gc = "nix-collect-garbage";
    limit = "systemd-run --scope -p MemoryHigh=33% -p CPUQuota=444%"; # Limit resources
    restrict = "systemd-run --scope -p MemoryHigh=66% -p CPUQuota=888%"; # Limit resources aggressively
    # egpu = "hyprctl keyword monitor eDP-1,disable"; # Disable internal monitor
    du = "dust";
    df = "duf -hide special";
    dfa = "duf -all";
    wcp = "wl-copy";
    wpt = "wl-paste";
    inhib = "systemd-inhibit sleep";
    compose = "podman compose";
    # Files
    a = "bat"; # Prettier cat to quickly display files in term
    restore = "trash-restore";
    empty = "trash-empty -i";
    d = "rm --recursive --verbose"; # Remove file(s) (thrash them in Nushell)
    shred = "shred -vu";
    wx = "watchexec";
    ## Quickly launch default text editor
    e = "${config.home.sessionVariables.EDITOR}"; # Default text editor
    "." = "${config.home.sessionVariables.EDITOR} ."; # Open editor in work dir
    ## Quick smart file/directory copy
    c = "systemd-inhibit rsync -v --recursive --update --mkpath --perms -h -P";
    ## Search
    bd = "br --sort-by-date";
    bs = "br --sort-by-size";
    bc = "br --sort-by-count";
    # Bluetooth & Network
    bt = "bluetoothctl";
    wi = "nmcli device wifi";
    wid = "nmcli device disconnect";
    http = "xh";
    https = "xh --https";
    # Media & Documents
    # pp = "playerctl play-pause";
    # next = "playerctl next";
    # prev = "playerctl previous";
    clic = "klick --auto-connect --interactive";
    clicmap = "klick --auto-connect --tempo-map";
    mix = "pulsemixer";
    scanpdf = "scanimage --format=pdf --batch --batch-prompt --progress --mode=color --resolution=400";
    compile-commands = "cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON"; # For LSP
    calc = "kalker"; # Do calculations
    uml = "plantuml -gui"; # Generate UML diagrams
    rs = "rust-script"; # Quickly run Rust file
    # Git
    clone = "git clone --verbose";
    status = "git status --verbose --ignored";
    fetch = "git fetch --verbose";
    pull = "git pull --recurse-submodules --jobs=8";
    remote = "git remote --verbose";
    checkout = "git checkout";
    gadd = "git add --verbose";
    commit = "git commit --verbose"; # Smarter function
    amend = "git commit --amend"; # Smarter function
    push = "git push --verbose";
    merge = "git merge";
    rebase = "git rebase";
    switch = "git switch";
    branch = "git branch";
    revert = "git revert";
    clean = "git clean --interactive -dx";
    stash = "git stash";
    giff = "git diff";
    logg = "git log --oneline";
    unamend = "git reset --soft HEAD@{1}";
    unstage = "git restore --staged";
    untrack = "git rm -r --cached";
    leak = "gitleaks dir --config ${../gitleaks.toml} --max-target-megabytes 1 --verbose";
  };
in
{
  # home.shellAliases = common; # Don’t works
  programs.zsh.shellAliases = common // {
    # System
    sudo = "sudo ";
    se = "sudoedit ";
    re = "exec zsh";
    # Files
    cp = "echo You might prefer using rsync alias 'c'; cp -urv"; # Reminder
    ts = "trash -v";
    rm = "echo 'Use ts to trash instead of removing'; rm -irv";
    mv = "mv -uv";
    # List
    sl = "ls --reverse";
    lsd = "ls -l -h --sort=time";
    sld = "ls -l -h --sort=time --reverse";
    ll = "ls -l -h";
    la = "ls -l -h --almost-all";
    al = "ls -l -h --almost-all --reverse";
    lt = "ls -l -h";
    # List, single letter
    l = "ls -l -h"; # Better ls
    g = "\\rga --smart-case --color=always"; # Better grep
    # Open, single letter
    x = "xdg-open"; # Open with the default tool
    o = "xdg-open"; # Open with the default tool
    p = "${config.home.sessionVariables.PAGER}"; # Default pager
    # Edit, single letter
    m = "mkdir -pv"; # mkdir with parents if needed
    # Git
    upsub = "git commit -am 'build: update submodule(s)'; git push";
    pupu = "git pull --recurse-submodules --jobs=8; git push";
  };
  programs.nushell.shellAliases = common // {
    # System
    re = "exec nu"; # Restart a shell, replacing the current one
    # Files
    m = "mkdir --verbose"; # Quickly create directory
    # Open, single letter
    # x = "start-bg"; # Open with the default tool
    o = "x"; # Open with the default tool
    p = "${config.home.sessionVariables.PAGER}"; # Default pager (ov)
    uml = "job spawn {plantuml -gui}"; # Generate UML diagrams
    # List
    l = "ls"; # Quickly list files in current directory
    ll = "ls --long"; # List all the data of the files in current directory
    la = "ls --all --long"; # List all the data of all files, hidden included
    g = "rga --smart-case --color=always"; # Search full text inside every file
  };
}
