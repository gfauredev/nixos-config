{ lib, pkgs, term, ... }: {
  home.packages =
    let
      smart-terminal = pkgs.writeShellScriptBin "t" ''
        [ -n "$1" ] && WD="$1" || WD="$PWD"
        shift
        [ -n "$1" ] && EXEC="${term.exec} $@"

        ${term.cmd} ${term.cd} $WD $EXEC & disown
      '';
      rsync-backup = pkgs.writeShellScriptBin "rsback" "${lib.readFile ./rsync-backup.sh}";
      extract = pkgs.writeShellScriptBin "ex" "${lib.readFile ./extract.sh}";
      veracrypt-mount = pkgs.writeShellScriptBin "veramount" "${lib.readFile ./veracrypt-mount.sh}";
      present-pdf = pkgs.writeShellScriptBin "present" "${lib.readFile ./present-pdf.sh}";
    in
    with pkgs; [
      # Custom scripts
      smart-terminal # Open a terminal quickly with first parameter always cd
      extract # Extract any compressed file
      rsync-backup # Incremental backup with rsync
      veracrypt-mount # Interactively mount veracrypt devices
      present-pdf # Present a PDF with a presenter console
      # TODO Place below in a shell/default.nix
      # Monitoring
      silver-searcher # Better grep
      fd # better find
      duf # global disk usage
      du-dust # disk usage of a directory
      bottom # htop alternative
      fastfetch # system info
      hexyl # hex viever
      # Files management
      trash-cli # Manage a trash from CLI
      sd # find & replace
      # nomino # Batch rename
    ];


  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    enableCompletion = true;
    # TEST revelance of each options below # TODO improve
    completionInit = ''
      autoload -Uz compinit && compinit -i && _comp_options+=(globdots)

      zstyle ':completion:*' completer _complete _approximate _expand_alias
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

      zstyle ':completion:*' menu select
      zmodload zsh/complist

      bindkey -M menuselect 'c' vi-backward-char
      bindkey -M menuselect 't' vi-down-line-or-history
      bindkey -M menuselect 's' vi-up-line-or-history
      bindkey -M menuselect 'r' vi-forward-char

      bindkey -M vicmd 'c' vi-backward-char
      bindkey -M vicmd 't' history-beginning-search-forward
      bindkey -M vicmd 's' history-beginning-search-backward
      bindkey -M vicmd 'r' vi-forward-char
    '';
    defaultKeymap = "viins";
    # dotDir = "${config.home-manager.users.gf.home.sessionVariables.XDG_CONFIG_HOME}/zsh"; # FIXME
    dotDir = ".config/zsh";
    history = {
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignorePatterns = [ ];
      ignoreSpace = true;
      path = "$ZDOTDIR/history"; # FIXME make this dependant on above
      size = 12420;
      share = true;
    };
    historySubstringSearch.enable = true;
    initExtra = builtins.readFile ./zshrc.sh; # TODO this more cleanly
    shellAliases =
      let
        ls = "eza --icons --git";
      in
      {
        sudo = "sudo ";
        se = "sudoedit ";

        # List
        ls = "${ls}";
        sl = "${ls} --reverse";
        lsd = "${ls} -l --no-permissions --sort=age";
        sld = "${ls} -l --no-permissions --sort=age --reverse";
        lss = "${ls} -l --no-permissions --time-style full-iso";
        ll = "${ls} -l --group";
        la = "${ls} -l --group -all";
        al = "${ls} -l --group -all --reverse";
        # Explore
        bd = "br --sort-by-date";
        bs = "br --sort-by-size";
        bc = "br --sort-by-count";

        # Copy, Move, Delete
        rm = "echo 'Use ts to trash instead of removing'; rm -irv";
        ts = "trash -v";
        empty = "trash-empty -i";
        restore = "trash-restore";
        shred = "shred -vu";
        mv = "mv -uv";
        cp = "echo You might prefer using custom command 'c';cp -urv"; # Reminder

        # System & Misc
        mix = "pulsemixer";
        du = "dust";
        df = "duf -hide special";
        dfa = "duf -all";
        sys = "systemctl";
        jo = "sudo journalctl -xfe";
        hist = "$EDITOR $ZDOTDIR/history";
        wi = "nmcli device wifi";
        wid = "nmcli device disconnect";
        re = "exec zsh";
        wcp = "wl-copy";
        wpt = "wl-paste";
        boot = "sudo bootctl";
        governor = "sudo cpupower frequency-set --governor"; # Set CPU frequency governor
        gc = "nix-collect-garbage";
        # wx = "watchexec";
        # run = "rofi -show-icons -show run";
        # steamos = "gamescope --steam -- steam -tenfoot"; # Steam gaming compositor
        ## Bluetooth & Network
        bt = "bluetoothctl";
        http = "xh";
        https = "xh --https";
        ## Media controls
        pp = "playerctl play-pause";
        next = "playerctl next";
        prev = "playerctl previous";
        inhib = "systemd-inhibit sleep";
        clic = "klick --auto-connect --interactive";
        clicmap = "klick --auto-connect --tempo-map";
        off = "systemctl poweroff";
        reboot = "systemctl reboot";
        ## Tools & Documents
        scanpdf = "scanimage --format=pdf --batch --batch-prompt --mode Color --resolution 600";
        mail = "himalaya"; # CLI mail client

        # Mounting
        mtp = "[ -d $HOME/mtp ] || mkdir $HOME/mtp; jmtpfs $HOME/mtp";
        unmtp = "fusermount -u $HOME/mtp; rmdir $HOME/mtp";
        usb = "[ -h $HOME/usb ] || ln -s /run/media/$USER $HOME/usb; udiskie-mount --all ; cd ~/usb";
        unusb = "cd ~ ; udiskie-umount --all --eject; \\rm $HOME/usb";

        # Git
        status = "git status";
        fetch = "git fetch -v";
        fetchd = "git fetch -v --dry-run";
        remote = "git remote -v";
        gadd = "git add";
        gadda = "git add .";
        commit = "git commit";
        commitm = "git commit -m";
        commita = "git commit -a";
        cmt = "git commit -am";
        amend = "git commit --amend";
        amendm = "git commit --amend -m";
        amenda = "git commit --amend -a";
        amendam = "git commit --amend -am";
        push = "git push";
        pusha = "git commit -am 'Unnamed update'; git push";
        upsub = "git commit -am 'Updated submodule(s)'; git push";
        pull = "git pull --recurse-submodules --jobs=16";
        pupu = "git pull --recurse-submodules --jobs=16 && git push";
        checkout = "git checkout";
        main = "git checkout main";
        merge = "git merge";
        mrg = "git mergetool --tool=nvimdiff";
        rebase = "git rebase";
        switch = "git switch";
        switchn = "git switch -c";
        revert = "git revert";
        branch = "git branch";
        clean = "git clean -idx";
        clone = "git clone -v";
        unstage = "git restore --staged";
        untrack = "git rm -r --cached";
        giff = "git diff";
        logg = "git log --oneline";
        ## Notes management
        # gitnote = "git --git-dir=$HOME/.note/ --work-tree=$HOME/note/";
        # gitnotecmt = "not commit -am";

        # ONE LETTER ALIASES, difficult to live without
        ## List & Search
        l = "${ls} -l --no-permissions --no-user"; # Better ls
        d = "z"; # Smart (frecent) cd
        f = "\\fd --color always"; # Better find
        fd = "echo You might prefer using custom command 'f';fd"; # Reminder
        g = "\\rga --smart-case --color=always"; # Better grep
        rg = "echo You might prefer using custom command 'g';rg"; # Reminder
        rga = "echo You might prefer using custom command 'g';rga"; # Reminder
        ## Open
        a = "bat --force-colorization --paging never"; # Better cat
        o = "open"; # xdg-open + disown
        p = "$PAGER"; # Default pager
        ## Edit
        e = "$EDITOR"; # Default text editor
        v = "vi"; # Vi(m) text editor
        u = "lapce"; # gUi text editor
        m = "mkdir -pv"; # mkdir (parents)
        c = "rsync -v --recursive --update --mkpath --perms -h -P"; # Better cp
        ## Multifunction (Explorers)
        b = "br"; # CLI fast files searcher
        x = "xplr"; # CLI files explorer
      };
  };

  programs = {
    # command-not-found.enable = true;
    eza = {
      enable = true; # Better ls
    };
    zoxide = {
      enable = true; # Smart cd
      enableZshIntegration = true;
    };
    starship = {
      enable = true; # Super prompt
      enableZshIntegration = true;
      settings = {
        character = {
          format = "$symbol ";
          # success_symbol = "[☭](bold green)";
          # error_symbol = "[\\$](bold red)";
          vimcmd_symbol = "[N](bold blue)";
          vimcmd_replace_one_symbol = "[r](bold blue)";
          vimcmd_replace_symbol = "[R](bold blue)";
          vimcmd_visual_symbol = "[V](bold blue)";
        };
      };
    };
    less = {
      enable = true; # Pager
      keys = ''
        t forw-line
        s back-line
        T forw-line-force
        S back-line-force
      '';
    };
    bat = {
      enable = true; # Better cat
      config = {
        pager = "less -i";
      };
    };
    fzf = {
      enable = true; # Fuzzy searcher
      enableZshIntegration = true;
    };
    ripgrep = {
      enable = true; # Better grep
      package = pkgs.ripgrep-all; # Search inside a lot of different file types
    };
  };
}
