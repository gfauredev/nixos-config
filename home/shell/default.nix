{ lib, pkgs, term, location, ... }: {
  home.packages = let
    smart-terminal = pkgs.writeShellScriptBin "t" ''
      wd=$PWD
      cmd=""
      if $SHELL -ic "which \"$1\""; then
        cmd="${term.exec} $SHELL -ic \"$@\""
      elif [ -d "$1" ]; then
        wd="$1"
        shift
        if $SHELL -ic "which \"$1\""; then
          cmd="${term.exec} $SHELL -ic \"$@\""
        fi
      fi
      echo "Running: ${term.cmd} ${term.cd} $wd $cmd & disown"
      ${term.cmd} ${term.cd} $wd $cmd & disown
      sleep 0.5
    '';
    extract = pkgs.writeShellScriptBin "ex" "${lib.readFile ./extract.sh}";
    configure = pkgs.writeShellScriptBin "cfg" ''
      CONFIG_DIR="${location}"
      ${lib.readFile ./configure.sh}
    '';
  in with pkgs; [
    smart-terminal # Open a terminal quickly with first parameter always cd
    extract # Extract any compressed file
    configure # Configure this flake config
    trash-cli # Manage a trash from CLI
    ripgrep-all # ripgrep for non-text files
    duf # global disk usage
    du-dust # detailed disk usage of a directory
    hexyl # hex viever
  ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
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
    # FIXME
    # dotDir = "${config.home-manager.users.gf.home.sessionVariables.XDG_CONFIG_HOME}/zsh";
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
    initExtra = builtins.readFile ./zshrc.sh; # TODO this cleaner
    shellAliases = let ls = "eza --icons --git";
    in {
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
      lt = "${ls} -l --tree";
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
      governor =
        "sudo cpupower frequency-set --governor"; # Set CPU frequency governor
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
      scanpdf =
        "scanimage --format=pdf --batch --batch-prompt --mode Color --resolution 600";
      typ = "typst compile *.typ"; # Quickly compile Typst files
      # mail = "himalaya"; # CLI mail client

      # Mounting
      mtp = "[ -d $HOME/mtp ] || mkdir $HOME/mtp; jmtpfs $HOME/mtp";
      unmtp = "fusermount -u $HOME/mtp; rmdir $HOME/mtp";
      usb =
        "[ -h $HOME/usb ] || ln -s /run/media/$USER $HOME/usb; udiskie-mount --all ; cd ~/usb";
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
    eza.enable = true; # Better ls
    fd.enable = true; # Better find
    ripgrep.enable = true; # Better grep
    bottom.enable = true; # Better top
    fastfetch.enable = true; # Quick system info
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
      config = { pager = "less -i"; };
    };
    fzf = {
      enable = true; # Fuzzy searcher
      enableZshIntegration = true;
    };
  };
}
