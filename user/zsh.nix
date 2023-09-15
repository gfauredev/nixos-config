{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; let
    empty_cr = pkgs.writeShellScript "empty_cr" ''
      empty_cr () { # clear screen & give info on empty line
        if [[ -z $BUFFER ]]; then
          clear
          echo $(date)
          # echo "Why I am doing what I do ?"
          if [ $(hostnamectl chassis) = "laptop" ]; then
            acpi -b
          fi
          echo
          exa --icons --git -l --no-permissions --no-user --sort=age
          if git rev-parse --git-dir > /dev/null 2>&1 ; then
            echo
            zsh -ic "status"
          fi
        fi
        zle accept-line
      }
      # Use this function when entering in an empty line
      zle -N empty_cr
      bindkey '^M' empty_cr
    '';
  in
  [
    empty_cr
  ];

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    enableCompletion = true;
    # TEST revelance of options below
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
    # dotDir = "${config.home-manager.users.gf.home.sessionVariables.XDG_CONFIG_HOME}/zsh";
    dotDir = ".config/zsh";
    history = {
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignorePatterns = [ ];
      ignoreSpace = true;
      path = "$XDG_CONFIG_HOME/zsh/zsh_history";
      # path = ".config/zsh/zsh_history";
      size = 12420;
      share = true;
    };
    historySubstringSearch.enable = true;
    # initExtra = '' # TODO directly with nix
    #   # create dl dir in user temp dir
    #   [ -d /run/user/''$(id -u)/dl ] || mkdir -m 700 /run/user/$(id -u)/dl
    #   # [ -h $XDG_DOWNLOAD_DIR ] || ln -s /run/user/$(id -u)/dl $XDG_DOWNLOAD_DIR # TODO do with home manager
    #   # delete some annoying dirs
    #   [ -d $HOME/Downloads ] && rmdir $HOME/Downloads
    #   [ -d $HOME/intelephense ] && rmdir $HOME/intelephense
    #
    #   source $XDG_CONFIG_HOME/functions.sh
    # '';
    shellAliases = {
      # sudo
      # su = "sudo su ";
      sudo = "sudo ";
      se = "sudoedit ";

      # List
      ls = "exa --icons --git";
      sl = "exa --icons --git --reverse";
      lsd = "exa --icons --git -l --no-permissions --sort=age";
      sld = "exa --icons --git -l --no-permissions --sort=age --reverse";
      lss = "exa --icons --git -l --no-permissions --time-style full-iso";
      # ll = "exa --icons --git -l --group --extended";
      ll = "exa --icons --git -l --group";
      # la = "exa --icons --git -l --group -all --extended";
      la = "exa --icons --git -l --group -all";
      al = "exa --icons --git -l --group -all --reverse";
      fd = "fd --color always";

      # Copy, Move, Delete
      rm = "rm -irv";
      ts = "trash -v";
      empty = "trash-empty -i";
      restore = "trash-restore";
      shred = "shred -vu";
      mv = "mv -uv";
      mvi = "mv -iv";
      cp = "cp -urv";
      cpi = "cp -irv";
      rs = "rsync -Prluvh";
      rsa = "rsync -Pauvh";
      # mvdl = "mv $HOME/dl/*";
      # cpdl = "cp $HOME/dl/*";

      # Edit, Open, Navigate
      ex = "$HOME/.local/bin/extract";
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
      hist = "$EDITOR $XDG_CONFIG_HOME/zsh/zsh_history";
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
      ## WARNING Hacky, TODO do this properly
      poweroff = "veracrypt -t -d && systemctl poweroff";
      off = "veracrypt -t -d && systemctl poweroff";
      reboot = "veracrypt -t -d && systemctl reboot";
      ## Tools & Documents
      # hu = "rm -frv public && hugo"; # TODO inside a specific shell
      # hu = "hugo --cleanDestinationDir";
      # tec = "pandoc --pdf-engine=tectonic"; # TODO inside a specific shell
      # wea = "pandoc --pdf-engine=weasyprint";
      # img = "swayimg"; # TODO with default openner
      scanpdf = "scanimage --format=pdf --batch --batch-prompt --mode Color --resolution 600";
      # mail = "aerc";

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
      cfg = "git --git-dir=$HOME/.bare/ --work-tree=$HOME";
      cfgs = "cfg status";
      cfgcmt = "cfg commit -am";
      cfgamend = "cfg commit --amend";
      cfgamendm = "cfg commit --amend -m";
      cfgamendam = "cfg commit --amend -am";
      # cfgcommit = "cfg commit";
      # cfgcommitm = "cfg commit -m";
      # cfgcommita = "cfg commit -a";
      ## Notes management
      not = "git --git-dir=$HOME/.note/ --work-tree=$HOME/note/";
      nots = "not status";
      notcmt = "not commit -am";
      notamend = "not commit --amend";
      notamendm = "not commit --amend -m";
      notamendam = "not commit --amend -am";

      # ONE LETTER ALIASES, difficult to live without
      ## List
      l = "exa --icons --git -l --no-permissions --no-user"; # quicker, beter ls
      g = "rga-fzf"; # search among all files contents
      ## Edit
      e = "$EDITOR"; # default text editor
      v = "vi"; # text editor
      h = "hx"; # text editor
      m = "mkdir -pv"; # quicker mkdir
      c = "rsync -v --recursive --update --mkpath --perms -h -P"; # better cp
      ## Open
      a = "bat --color always"; # quicker, better cat
      o = "open"; # quicker, better xdg-open
      p = "$PAGER"; # quicker default pager
      ## Navigate
      d = "z"; # quicker, better, smarter cd
      f = "fd"; # quicker, better find
      b = "br"; # CLI files explorer
      t = "term"; # smart terminal window opener
      # x = "xplr"; # CLI files explorer
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
    # fzf = { # TEST relevance
    #   enable = true;
    #   enableZshIntegration = true;
    #   keybindings = true;
    #   fuzzyCompletion = true;
    # };
  };
}
