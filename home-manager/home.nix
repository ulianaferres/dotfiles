{ config, pkgs, ... }:

{
  home.username = "uliana";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    font-awesome
    kitty
    nixfmt
    telegram-desktop
    glib
    typst
    typstyle
    unzip
    unrar
    vimgolf
    p7zip
    zoxide
    fzf
    coreutils-full
    git-quick-stats
    gnumake
    inkscape
    tree
    zstd
    walk
    rsync
    watch
    bmon
    nmap
    ncdu

    pciutils
    tmux
    ipmitool
    teams-for-linux
    screen
    killall
    file
    gcc
    fastfetch
    algotex
    smartmontools
    btop
    sshfs
    icu
    discord
    vesktop
    google-chrome
    feishin
    spotify
    neofetch
    obsidian
    zotero
    signal-desktop-bin
    prismlauncher
    git
    mpv
    ffmpeg
    #darktable
    thunderbird
    zoom-us
    wget
    cabextract
    ookla-speedtest
    iperf
    iperf2
    python311Packages.pygments
  ];

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs = {
    home-manager.enable = true;
    gpg.enable = true;
    firefox.enable = true;
    zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
      };
      autosuggestion = {
        enable = true;
      };
      enableCompletion = true;
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
      ];
      initContent = ''
        source ~/.p10k.zsh
      '';
    };
    java = {
      enable = true;
      package = pkgs.jdk25;
    };
    vscode = {
      enable = true;
      mutableExtensionsDir = true;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        ms-vscode-remote.remote-ssh
        tamasfe.even-better-toml
        redhat.vscode-yaml
        ms-python.python
        mhutchie.git-graph
        arturock.gitstash
        t3dotgg.vsc-material-theme-but-i-wont-sue-you
        james-yu.latex-workshop
        jnoortheen.nix-ide
        myriad-dreamin.tinymist
        tomoki1207.pdf
        vscodevim.vim
        k--kato.intellij-idea-keybindings
        # git stuff
        donjayamanne.githistory
        eamodio.gitlens
        codezombiech.gitignore
      ];
    };
    nano = {
      enable = true;
      nanorc = ''
        set tabsize 2
        set tabstospaces
      '';
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentry.package = if pkgs.stdenv.isLinux then pkgs.pinentry-all else pkgs.pinentry_mac;
  };
}
