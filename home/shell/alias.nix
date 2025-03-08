{ config, ... }:
let
  config_location = "~/.config/flake"; # TODO define in top level flake.nix
  eza_cfg = "eza --icons --git";
  # commitlint_cfg = "commitlint --config ~/.config/commitlintrc.yaml";
  common = {
    # System
    sudo = "sudo ";
    se = "sudoedit ";
    boot = "sudo bootctl";
    reboot = "systemctl reboot";
    off = "systemctl poweroff";
    cfg = "cd ${config_location}; configure"; # Configure NixOS and Home Manager
    sys = "systemctl";
    jo = "sudo journalctl -xfe";
    gc = "nix-collect-garbage";
    performance =
      "sudo cpupower frequency-set --governor performance"; # Performance mode
    powersave =
      "sudo cpupower frequency-set --governor powersave"; # Powersave mode
    egpu = "hyprctl keyword monitor eDP-1,disable"; # Disable internal monitor
    du = "dust";
    df = "duf -hide special";
    dfa = "duf -all";
    wcp = "wl-copy";
    wpt = "wl-paste";
    inhib = "systemd-inhibit sleep";
    # Files
    ts = "trash -v";
    restore = "trash-restore";
    empty = "trash-empty -i";
    shred = "shred -vu";
    wx = "watchexec";
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
    pp = "playerctl play-pause";
    next = "playerctl next";
    prev = "playerctl previous";
    clic = "klick --auto-connect --interactive";
    clicmap = "klick --auto-connect --tempo-map";
    mix = "pulsemixer";
    scanpdf =
      "scanimage --format=pdf --batch --batch-prompt --mode Color --resolution 600";
    # Git
    clone = "git clone -v";
    status = "git status";
    fetch = "git fetch -v";
    pull = "git pull --recurse-submodules --jobs=8";
    remote = "git remote -v";
    checkout = "git checkout";
    gadd = "git add";
    commit = "git commit"; # Smarter function
    amend = "git commit --amend"; # Smarter function
    push = "git push";
    merge = "git merge";
    rebase = "git rebase";
    switch = "git switch";
    branch = "git branch";
    revert = "git revert";
    clean = "git clean -idx";
    giff = "git diff";
    logg = "git log --oneline";
    unamend = "git reset --soft HEAD@{1}";
    unstage = "git restore --staged";
    untrack = "git rm -r --cached";
    # Open ONE LETTER
    x = "xopen"; # xdg-open as separate process
    a = "bat --force-colorization"; # --paging never"; # Better cat
    p = "${config.home.sessionVariables.PAGER}"; # Default pager
    # Edit ONE LETTER
    e = "${config.home.sessionVariables.EDITOR}"; # Default text editor
    c = "systemd-inhibit rsync -v --recursive --update --mkpath --perms -h -P";
  };
in {
  # home.shellAliases = common; # Don’t works
  programs.zsh.shellAliases = common // {
    # System
    re = "exec zsh";
    # Files
    cp = "echo You might prefer using rsync alias 'c'; cp -urv"; # Reminder
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
    # List & Search ONE LETTER
    l = "${eza_cfg} -l --no-permissions --no-user"; # Better ls
    g = "\\rga --smart-case --color=always"; # Better grep
    # Open ONE LETTER
    o = "xopen"; # xdg-open as separate process
    # Edit ONE LETTER
    m = "mkdir -pv"; # mkdir with parents if needed
    # Git
    upsub = "git commit -am 'build: update submodule(s)'; git push";
    pupu = "git pull --recurse-submodules --jobs=8; git push";
  };
  programs.nushell.shellAliases = common // {
    # System
    re = "exec nu";
    # Files
    rm = "rm --verbose"; # TODO trash by default
    # List
    l = "ls"; # Quick ls
    ll = "ls --long"; # List all the data
    la = "ls --all --long"; # List all the data of all files, hidden included
    # List & Search ONE LETTER
    g = "rga --smart-case --color=always"; # Better grep
    # Open ONE LETTER
    o = "open"; # nushell’s open
    # Edit ONE LETTER
    m = "mkdir --verbose"; # Quick mkdir
  };
}
