{ ... }:
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
    mv = "mv -uv";
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
  };
in {
  # home.shellAliases = common; # Don’t works
  programs.zsh.shellAliases = common // {
    # System
    re = "exec zsh";
    # Files
    cp = "echo You might prefer using rsync alias 'c'; cp -urv"; # Reminder
    rm = "echo 'Use ts to trash instead of removing'; rm -irv";
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
    o = "open"; # xdg-open + disown
    a = "bat --force-colorization"; # --paging never"; # Better cat
    p = "$PAGER"; # Default pager
    # Edit ONE LETTER
    e = "$EDITOR"; # Default text editor
    m = "mkdir -pv"; # mkdir with parents if needed
    c = "systemd-inhibit rsync -v --recursive --update --mkpath --perms -h -P";
    # Git
    upsub = "git commit -am 'build: update submodule(s)'; git push";
    pupu = "git pull --recurse-submodules --jobs=8; git push";
  };
  programs.nushell.shellAliases = common // {
    # System
    re = "exec nu";
    status = "git status"; # WARN temporary, waiting for CR shortcut
    # List
    l = "ls"; # Better ls
    ll = "ls --long";
    la = "ls --all --long";
    # List & Search ONE LETTER
    g = "rga --smart-case --color=always"; # Better grep
    # Open ONE LETTER
    x = "xopen"; # xdg-open
    o = "open"; # nushell’s open
    a = "bat --force-colorization"; # --paging never"; # Better cat
    # Edit ONE LETTER
    e = "run-external $env.EDITOR"; # Default text editor
    m = "mkdir"; # Quick mkdir
    c = "systemd-inhibit rsync -v --recursive --update --mkpath --perms -h -P";
  };
}
