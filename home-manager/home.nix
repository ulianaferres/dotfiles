{ config, pkgs, ... }:

{
  home.username = "alex";
  home.homeDirectory = "/home/alex";
  home.stateVersion = "24.11";
#  home.enableNixpkgsReleaseCheck = false;

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    inkscape
    gnumake
    cargo
    wl-clipboard
    qbittorrent
    pciutils
    tmux
    ipmitool
    teams-for-linux
    gst_all_1.gstreamer
    neovim
    yarn
    nodejs_23
    screen
    killall
    file
    gh
    gcc
    fastfetch
    algotex
    smartmontools
    btop
    sshfs
    icu
    popsicle
    powertop
    s-tui
    vesktop
    google-chrome
    feishin
    whatsapp-for-linux
    spotify
    neofetch
    jetbrains.idea-ultimate
    jetbrains.clion
    obsidian
    zotero
    signal-desktop
    makemkv
    prismlauncher
    git
    mpv
    ffmpeg
    darktable
    thunderbird
    kotlin
    dafny
    dotnet-sdk
    #docker
    k9s
    kubectl
    minikube
    gradle
    scala
    scala-cli
    sbt
    zoom-us
    resilio-sync
    #texliveFull
    wget
    cabextract
    obs-studio
    podman
    ethtool
    ookla-speedtest
    iperf
    iperf2
    gamescope
    jellyfin-media-player
    pinentry-all
    nerd-fonts.droid-sans-mono
    python311Packages.pygments
  ];


  home.file = {
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
      initExtra = ''
        source ~/.p10k.zsh
      '';
    };
    java = {
      enable = true;
      package = pkgs.jdk23;
    };
    vscode = {
      enable = true;
      profiles.default.extensions = with pkgs.vscode-extensions; [
       # dafny-lang
      ];
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryPackage = pkgs.pinentry-all;
  };
}
