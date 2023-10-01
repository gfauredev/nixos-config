{ inputs, lib, config, pkgs, ... }: {
  home.packages =
    let
      smart-terminal = pkgs.writeShellScriptBin "t" "${lib.readFile ../script+data/smart-terminal.sh}";
      typst-env = pkgs.writeShellScriptBin "typ" "${lib.readFile ../script+data/typst-env.sh}"; # TODO make typst-env built into docu dev shell
      rsync-backup = pkgs.writeShellScriptBin "rsback" "${lib.readFile ../script+data/rsync-backup.sh}";
      fingerprints-enroll = pkgs.writeShellScriptBin "fingers" "${lib.readFile ../script+data/fingerprints-enroll.sh}";
      extract = pkgs.writeShellScriptBin "ex" "${lib.readFile ../script+data/fingerprints-enroll.sh}";
      veracrypt-mount = pkgs.writeShellScriptBin "veramount" "${lib.readFile ../script+data/veracrypt-mount.sh}";
      present-pdf = pkgs.writeShellScriptBin "present" "${lib.readFile ../script+data/present-pdf.sh}";
    in
    [
      pkgs.eza # ls replacement (exa fork)
      # Custom scripts
      smart-terminal # Open a terminal more smartly
      typst-env # Setup typst writing env TODO move to dev shell
      extract # Extract any compressed file
      rsync-backup # Incremental backup with rsync
      fingerprints-enroll # Enroll fingers for finger print reader
      veracrypt-mount # Interactively mount veracrypt devices
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
    initExtra = builtins.readFile ../script+data/zshrc.sh; # TODO this more cleanly
    shellAliases = {
      # sudo
      # su = "sudo su ";
      sudo = "sudo ";
      se = "sudoedit ";

      # List
      ls = "eza --icons --git";
      sl = "eza --icons --git --reverse";
      lsd = "eza --icons --git -l --no-permissions --sort=age";
      sld = "eza --icons --git -l --no-permissions --sort=age --reverse";
      lss = "eza --icons --git -l --no-permissions --time-style full-iso";
      # ll = "eza --icons --git -l --group --extended";
      ll = "eza --icons --git -l --group";
      # la = "eza --icons --git -l --group -all --extended";
      la = "eza --icons --git -l --group -all";
      al = "eza --icons --git -l --group -all --reverse";
      fd = "fd --color always";

      # Copy, Move, Delete
      rm = "rm -irv";
      ts = "trash -v";
      empty = "trash-empty -i";
      restore = "trash-restore";
      shred = "shred -vu";
      mv = "mv -uv";
      # mvi = "mv -iv";
      cp = "cp -urv";
      # cpi = "cp -irv";
      # rs = "rsync -Prluvh";
      # rsa = "rsync -Pauvh";
      # mvdl = "mv $HOME/dl/*";
      # cpdl = "cp $HOME/dl/*";

      # Edit, Open, Navigate
      rg = "rg -S -C 2";
      ## Quick access to parent directories
      # "..." = "../../";
      # "...." = "../../../";
      # "....." = "../../../../";
      # "......" = "../../../../../";
      # "......." = "../../../../../../";

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
      # py = "python3"; # TODO inside specific shells
      # py = "python";
      # pi = "ipython -i --ext=autoreload --ext=storemagic";
      # pi = "python -i";
      # ju = "term jupyter-notebook .";
      wcp = "wl-copy";
      wpt = "wl-paste";
      # neo = "neofetch";
      boot = "sudo bootctl";
      # rebuild = "sudo nixos-rebuild -v"; # TODO for flake system
      # update = "sudo nix-channel --update"; # TODO for flake system
      gc = "nix-collect-garbage";
      wx = "watchexec";
      ## Bluetooth & Network
      bt = "bluetoothctl";
      # btc = "bluetoothctl connect";
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
      # hu = "rm -frv public && hugo"; # TODO inside a specific shell
      # hu = "hugo --cleanDestinationDir"; # TODO inside a specific shell
      # tec = "pandoc --pdf-engine=tectonic"; # TODO inside a specific shell
      # wea = "pandoc --pdf-engine=weasyprint"; # TODO inside a specific shell

      # Mounting
      mtp = "mkdir $HOME/mtp; jmtpfs $HOME/mtp";
      mtpu = "fusermount -u $HOME/mtp && rmdir $HOME/mtp";
      usbu = "udiskie-umount --all --eject";
      # usbe = "udiskie-umount --all --eject";
      # mtpm = "mkdir $HOME/mtp ; sudo aft-mtp-mount $HOME/mtp";
      # udm = "udisksctl mount -b";
      # udu = "udisksctl unmount -b";
      # mnt = "sudo mount -o umask=027,uid=$(id -u),gid=$(id -g)";
      # usba = "udiskie-mount --all";
      # usbu = "udiskie-umount";
      # usbe = "udiskie-umount --detach --eject";

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
      ## Config files management
      # cfg = "git --git-dir=$HOME/.bare/ --work-tree=$HOME";
      # cfgs = "cfg status";
      # cfgcmt = "cfg commit -am";
      # cfgamend = "cfg commit --amend";
      # cfgamendm = "cfg commit --amend -m";
      # cfgamendam = "cfg commit --amend -am";
      # cfgcommit = "cfg commit";
      # cfgcommitm = "cfg commit -m";
      # cfgcommita = "cfg commit -a";
      ## Notes management
      not = "git --git-dir=$HOME/.note/ --work-tree=$HOME/note/";
      # nots = "not status";
      # notcmt = "not commit -am";
      # notamend = "not commit --amend";
      # notamendm = "not commit --amend -m";
      # notamendam = "not commit --amend -am";

      # ONE LETTER ALIASES, difficult to live without
      ## List & Search
      l = "eza --icons --git -l --no-permissions --no-user"; # quicker, beter ls
      d = "z"; # quicker, better, smarter cd
      f = "fd"; # quicker, better find
      # t = "term"; # smart terminal window opener
      # g = "rga-fzf"; # search among all files contents

      ## Open
      a = "bat --color always"; # quicker, better cat
      o = "open"; # quicker, better xdg-open
      p = "$PAGER"; # quicker default pager

      ## Edit
      e = "$EDITOR"; # default text editor
      v = "vi"; # text editor
      h = "hx"; # text editor
      m = "mkdir -pv"; # quicker mkdir
      c = "rsync -v --recursive --update --mkpath --perms -h -P"; # better cp
      ## Multifunction
      b = "br"; # CLI files explorer
      x = "xplr"; # CLI files explorer
      n = "nnn"; # CLI files explorer
    };
    shellGlobalAliases = {
      AUD = "$HOME/aud";
      COD = "$HOME/cod";
      DL = "$HOME/dl";
      DOC = "$HOME/doc";
      IMG = "$HOME/img";
      NOTE = "$HOME/in";
      USB = "$HOME/usb";
    };
  };

  programs = {
    command-not-found.enable = true;
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    starship = {
      enable = true;
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
      enable = true;
      keys = ''
        t forw-line
        s back-line
        T forw-line-force
        S back-line-force
      '';
    };
    bat = {
      enable = true;
      config = {
        pager = "less -i";
      };
    };
    fzf = {
      enable = true; # TEST relevance
      enableZshIntegration = true;
    };
  };
}
