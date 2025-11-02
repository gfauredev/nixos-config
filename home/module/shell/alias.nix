{ config, ... }:
let
  eza_cfg = "eza --icons --git";
  # commitlint_cfg = "commitlint --config ~/.config/commitlintrc.yaml";
  common = {
    # System
    sudo = "sudo ";
    se = "sudoedit ";
    boot = "sudo bootctl";
    reboot = "systemctl reboot";
    off = "systemctl poweroff";
    sys = "systemctl";
    jo = "sudo journalctl -xfe";
    gc = "nix store gc";
    # gc = "nix-collect-garbage";
    performance = "sudo cpupower frequency-set --governor performance"; # Performance mode
    powersave = "sudo cpupower frequency-set --governor powersave"; # Powersave mode
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
    scanpdf = "scanimage --format=pdf --batch --batch-prompt --mode Color --resolution 600";
    compile-commands = "cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON"; # For LSP
    calc = "kalker"; # Do calculations
    uml = "plantuml -darkmode -gui"; # Generate UML diagrams
    plantuml = "plantuml -tsvg -darkmode -filename diagram.svg";
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
  };
in
{
  # home.shellAliases = common; # Don’t works
  programs.zsh.shellAliases = common // {
    # System
    re = "exec zsh";
    # Files
    cp = "echo You might prefer using rsync alias 'c'; cp -urv"; # Reminder
    ts = "trash -v";
    rm = "echo 'Use ts to trash instead of removing'; rm -irv";
    mv = "mv -uv";
    # List
    ls = "${eza_cfg}";
    sl = "${eza_cfg} --reverse";
    lsd = "${eza_cfg} -l --no-permissions --sort=age";
    sld = "${eza_cfg} -l --no-permissions --sort=age --reverse";
    lss = "${eza_cfg} -l --no-permissions --time-style full-iso";
    ll = "${eza_cfg} -l --group";
    la = "${eza_cfg} -l --group -all";
    al = "${eza_cfg} -l --group -all --reverse";
    lt = "${eza_cfg} -l --tree";
    # List, single letter
    l = "${eza_cfg} -l --no-permissions --no-user"; # Better ls
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
    x = "start-bg"; # Open with the default tool
    o = "start-bg"; # Open with the default tool
    p = "${config.home.sessionVariables.PAGER}"; # Default pager (ov)
    # List
    l = "ls"; # Quickly list files in current directory
    ll = "ls --long"; # List all the data of the files in current directory
    la = "ls --all --long"; # List all the data of all files, hidden included
    g = "rga --smart-case --color=always"; # Search full text inside every file
  };
}
