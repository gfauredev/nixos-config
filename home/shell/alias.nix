{ lib, ... }: {
  programs.zsh.shellAliases = let ls = "eza --icons --git";
  in {
    sudo = "sudo ";
    se = "sudoedit ";

    # Files
    cp = "echo You might prefer using custom command 'c';cp -urv"; # Reminder
    mv = "mv -uv";
    ts = "trash -v";
    rm = "echo 'Use ts to trash instead of removing'; rm -irv";
    restore = "trash-restore";
    empty = "trash-empty -i";
    shred = "shred -vu";
    ## List
    ls = "${ls}";
    sl = "${ls} --reverse";
    lsd = "${ls} -l --no-permissions --sort=age";
    sld = "${ls} -l --no-permissions --sort=age --reverse";
    lss = "${ls} -l --no-permissions --time-style full-iso";
    ll = "${ls} -l --group";
    la = "${ls} -l --group -all";
    al = "${ls} -l --group -all --reverse";
    lt = "${ls} -l --tree";
    bd = "br --sort-by-date";
    bs = "br --sort-by-size";
    bc = "br --sort-by-count";

    # System
    boot = "sudo bootctl";
    reboot = "systemctl reboot";
    off = "systemctl poweroff";
    sys = "systemctl";
    jo = "sudo journalctl -xfe";
    re = "exec zsh";
    gc = "nix-collect-garbage";
    performance =
      "sudo cpupower frequency-set --governor performance"; # Performance mode
    powersave =
      "sudo cpupower frequency-set --governor powersave"; # Powersave mode
    egpu = "hyprctl keyword monitor eDP-1,disable"; # Disable internal monitor

    # Tools
    du = "dust";
    df = "duf -hide special";
    dfa = "duf -all";
    hist = "$EDITOR $ZDOTDIR/history";
    wcp = "wl-copy";
    wpt = "wl-paste";
    http = "xh";
    https = "xh --https";
    wx = "watchexec";

    # Bluetooth & Network
    bt = "bluetoothctl";
    wi = "nmcli device wifi";
    wid = "nmcli device disconnect";

    # Media
    pp = "playerctl play-pause";
    next = "playerctl next";
    prev = "playerctl previous";
    # inhib = "systemd-inhibit sleep";
    clic = "klick --auto-connect --interactive";
    clicmap = "klick --auto-connect --tempo-map";
    mix = "pulsemixer";

    # Documents
    scanpdf =
      "scanimage --format=pdf --batch --batch-prompt --mode Color --resolution 600";

    # Mounts
    mtp = "[ -d $HOME/mtp ] || mkdir $HOME/mtp; jmtpfs $HOME/mtp";
    unmtp = "fusermount -u $HOME/mtp; rmdir $HOME/mtp";

    # Git
    clone = "git clone -v";
    fetch = "git fetch -v";
    pull = "git pull --recurse-submodules --jobs=8";
    remote = "git remote -v";
    checkout = "git checkout";
    gadd = "git add";
    # commit = "git commit";
    # amend = "git commit --amend";
    push = "git push";
    merge = "git merge";
    rebase = "git rebase";
    switch = "git switch";
    branch = "git branch";
    revert = "git revert";
    clean = "git clean -idx";
    giff = "git diff";
    logg = "git log --oneline";
    upsub = ''
      git commit -am 'chore: update submodule(s)' \
      commitlint --config ~/.config/commitlintrc.yaml && git push
    '';
    pupu = "git pull --recurse-submodules --jobs=8 && git push";
    unamend = "git reset --soft HEAD@{1}";
    unstage = "git restore --staged";
    untrack = "git rm -r --cached";

    # ONE LETTER ALIASES, difficult to live without
    ## List & Search
    l = "${ls} -l --no-permissions --no-user"; # Better ls
    d = "z"; # Smart (frecent) cd
    f = "\\fd --color always"; # Better find
    fd = lib.mkForce
      "echo You might prefer using custom command 'f';fd"; # Reminder
    g = "\\rga --smart-case --color=always"; # Better grep
    rg = "echo You might prefer using custom command 'g';rg"; # Reminder
    rga = "echo You might prefer using custom command 'g';rga"; # Reminder
    ## Open
    a = "bat --force-colorization"; # --paging never"; # Better cat
    o = "open"; # xdg-open + disown
    p = "$PAGER"; # Default pager
    ## Edit
    e = "$EDITOR"; # Default text editor
    # v = "vi"; # (Neo)Vi(m) CLI text editor (fallback)
    # h = "hx"; # Helix CLI text editor (fallback)
    # u = "zeditor"; # gUi text editor
    m = "mkdir -pv"; # mkdir (parents)
    # c = "systemd-inhibit rsync -v --recursive --update --mkpath --perms -h -P";
    ## Multifunction (Explorers)
    b = "br"; # CLI fast files searcher
  };
}
