{ inputs, lib, config, pkgs, ... }: {
  home.packages =
    let
      rsback = pkgs.writeShellScriptBin "rsync_backup" ''
        if [ -n "$1" ]; then
          readonly SOURCE_DIR="$(realpath "$1")"
        else
          readonly SOURCE_DIR="$HOME/.data"
        fi
        echo "Backup $SOURCE_DIR"

        if [ -n "$2" ]; then
          readonly BACKUPS_DIR="$(realpath "$2")"
        else
          readonly BACKUPS_DIR="$HOME/.backup"
        fi
        echo "Into $BACKUPS_DIR"

        readonly DATE="$(date '+%Y-%m-%d_%H:%M:%S')"
        readonly THIS_BACKUP_DIR="$BACKUPS_DIR/$DATE"
        readonly LATEST_LINK="$BACKUPS_DIR/latest-backup"

        echo "Creating new backup at $THIS_BACKUP_DIR"
        mkdir -p $THIS_BACKUP_DIR

        echo "Beginning transfer"
        rsync -vah --progress --delete \
          "$SOURCE_DIR/" \
          --link-dest "$LATEST_LINK" \
          "$THIS_BACKUP_DIR"

        echo "Delete previous link & create new"
        rm -fr "$LATEST_LINK"
        ln -fs "$THIS_BACKUP_DIR" "$LATEST_LINK"
      '';
      fingers = pkgs.writeShellScriptBin "enroll_fingers" ''
        for finger in {left-middle-finger,left-index-finger,right-thumb,right-index-finger,right-middle-finger}; do
          echo "PREPARE YOUR $finger, ENROLL IS COMING …"
          sleep 2
          sudo fprintd-enroll -f "$finger" gf
        done
      '';
      ex = pkgs.writeShellScriptBin "extract" ''
        if [ -z "$1" ]; then
            # display usage if no parameters given
            echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
            echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
        else
            for n in "$@"
            do
              if [ -f "$n" ] ; then
                  case "''${n%,}" in
                    *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                                            tar xvf "$n"       ;;
                    *.lzma)                 unlzma ./"$n"      ;;
                    *.bz2)                  bunzip2 ./"$n"     ;;
                    *.cbr|*.rar)            unrar x -ad ./"$n" ;;
                    *.gz)                   gunzip ./"$n"      ;;
                    *.cbz|*.epub|*.zip)     unzip ./"$n"       ;;
                    *.z)                    uncompress ./"$n"  ;;
                    *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                                            7z x ./"$n"        ;;
                    *.xz)                   unxz ./"$n"        ;;
                    *.exe)                  cabextract ./"$n"  ;;
                    *.cpio)                 cpio -id < ./"$n"  ;;
                    *.cba|*.ace)            unace x ./"$n"     ;;
                    *)
                                            echo "extract: '$n' - unknown archive method"
                                            return 1 ;;
                  esac
              else
                  echo "'$n' - file does not exist"
                  return 1
              fi
            done
        fi
      '';
      veramount = pkgs.writeShellScriptBin "veracrypt_mount" ''
        lsblk -o PATH,SIZE,TYPE,LABEL
        read -p "Device to decrypt (auto mount all) /dev/" device

        if [ -n "$device" ]; then
          # Decrypt the single device the user requested
          veracrypt -t --filesystem=none "/dev/$device"
        else
          # Decrypt all veracrypt devices
          veracrypt -t --auto-mount=devices --filesystem=none
        fi

        defaultDecrypt="veracrypt1"
        defaultPoint=".data"

        lsblk -o PATH,SIZE,TYPE,LABEL
        # Ask the user for a decrypted device to mount, defaults to loop0
        read -p "Decrypted device to mount ($defaultDecrypt) /dev/mapper/" decrypt
        # read -p "Mount point (leave not mounted) : " point
        read -p "Mount point (.data) : " point

        # Mount a device for the user
        if [ "$decrypt" == "" ]; then
          decrypt="$defaultDecrypt"
        fi

        if [ -n "$point" ]; then
            sudo mount -o uid=$(id -u),gid=$(id -g),umask=027 /dev/mapper/$decrypt $point
          else
            sudo mount -o uid=$(id -u),gid=$(id -g),umask=027 /dev/mapper/$decrypt $defaultPoint
        fi
      '';
    in
    [
      ex # Extract any compressed file
      rsback # Incremental backup with rsync
      fingers # Enroll fingers for finger print reader
      veramount # Interactively mount veracrypt devices
    ];


  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    enableCompletion = true;
    # TEST revelance of each options below
    # TODO improve
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
    # TODO this more cleanly
    initExtra = builtins.readFile ../zshrc.sh;
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
      l = "eza --icons --git -l --no-permissions --no-user"; # quicker, beter ls
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
    fzf = {
      enable = true; # TEST relevance
      enableZshIntegration = true;
    };
  };
}
