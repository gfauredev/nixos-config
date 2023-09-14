{ inputs, lib, config, pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    enableCompletion = true;
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
    initExtra = ''
      # create dl dir in user temp dir
      [ -d /run/user/''$(id -u)/dl ] || mkdir -m 700 /run/user/$(id -u)/dl
      # [ -h $XDG_DOWNLOAD_DIR ] || ln -s /run/user/$(id -u)/dl $XDG_DOWNLOAD_DIR # TODO do with home manager
      # delete some annoying dirs
      [ -d $HOME/Downloads ] && rmdir $HOME/Downloads
      [ -d $HOME/intelephense ] && rmdir $HOME/intelephense

      source $XDG_CONFIG_HOME/functions.sh
    '';
    shellAliases = {
      # sudo
      su = "sudo su ";
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
      destroy = "shred -vu";
      mv = "mv -uv";
      mvi = "mv -iv";
      cp = "cp -urv";
      cpi = "cp -irv";
      rs = "rsync -Prluvh";
      rsa = "rsync -Pauvh";
      mvdl = "mv $HOME/dl/*";
      cpdl = "cp $HOME/dl/*";

      # Edit, Open, Navigate
      ex = "$HOME/.local/bin/extract";
      rg = "rg -S -C 2";
      ## Parent directories
      "..." = "../../";
      "...." = "../../../";
      "....." = "../../../../";
      "......" = "../../../../../";
      "......." = "../../../../../../";

      # System & Misc
      mix = "pulsemixer";
      du = "dust";
      df = "duf -hide special";
      dfa = "duf -all";
      sys = "sudo systemctl";
      jo = "sudo journalctl -xfe";
      hist = "$EDITOR $XDG_CONFIG_HOME/zsh/zsh_history";
      wi = "nmcli device wifi";
      wid = "nmcli device disconnect";
      re = "exec zsh";
      # py = "python3";
      py = "python";
      # pi = "ipython -i --ext=autoreload --ext=storemagic";
      pi = "python -i";
      ju = "term jupyter-notebook .";
      wcp = "wl-copy";
      wpt = "wl-paste";
      neo = "neofetch";
      boot = "sudo bootctl";
      rebuild = "sudo nixos-rebuild -v";
      update = "sudo nix-channel --update";
      gc = "nix-collect-garbage";
      wx = "watchexec";
      ## Bluetooth & Network
      bt = "bluetoothctl";
      btc = "bluetoothctl connect";
      http = "xh";
      https = "xh --https";
      ## Media controls
      pp = "playerctl play-pause";
      next = "playerctl next";
      prev = "playerctl previous";
      inhib = "systemd-inhibit sleep";
      clic = "klick --auto-connect --interactive";
      clif = "klick --auto-connect --tempo-map";
      ## WARNING Hacky, find a way to do this properly
      poweroff = "veracrypt -t -d && systemctl poweroff";
      off = "veracrypt -t -d && systemctl poweroff";
      reboot = "veracrypt -t -d && systemctl reboot";
      ## Tools & Documents
      # hu = "rm -frv public && hugo";
      hu = "hugo --cleanDestinationDir";
      tec = "pandoc --pdf-engine=tectonic";
      wea = "pandoc --pdf-engine=weasyprint";
      rust = "nix-shell $XDG_CONFIG_HOME/nix/shells/rust.nix";
      img = "swayimg";
      scanpdf = "scanimage --format=pdf --batch --batch-prompt --mode Color --resolution 600";
      mail = "aerc";

      # Mounting
      # mtpm = "mkdir $HOME/mtp ; sudo aft-mtp-mount $HOME/mtp";
      mtp = "mkdir $HOME/mtp; jmtpfs $HOME/mtp";
      mtpu = "fusermount -u $HOME/mtp && rmdir $HOME/mtp";
      udm = "udisksctl mount -b";
      udu = "udisksctl unmount -b";
      mnt = "sudo mount -o umask=027,uid=$(id -u),gid=$(id -g)";
      # usba = "udiskie-mount --all";
      # usbu = "udiskie-umount";
      # usbe = "udiskie-umount --detach --eject";
      usbe = "udiskie-umount --all --eject";

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
      pu = "git pull --recurse-submodules --jobs=16 && git push";
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
      cfgcommit = "cfg commit";
      cfgcommitm = "cfg commit -m";
      cfgcommita = "cfg commit -a";
      cfgamend = "cfg commit --amend -a";
      cfgamendm = "cfg commit --amend -m";
      cfgamendam = "cfg commit --amend -am";
      cfgcmt = "cfg commit -am";

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
      x = "xplr"; # CLI files explorer
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
    fzf = {
      enable = true;
      enableZshIntegration = true;
      # keybindings = true;
      # fuzzyCompletion = true;
    };
    bat = {
      enable = true;
      config = {
        pager = "less -i";
      };
    };
  };
}
