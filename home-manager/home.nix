{ config, pkgs, ... }:

{
  home.username = "alex";
  home.homeDirectory =
    if pkgs.stdenv.isLinux then
      "/home/alex"
    else
      "/Users/alex";

  home.stateVersion = "24.11";
#  home.enableNixpkgsReleaseCheck = false;

#  fonts.fontconfig.enable = pkgs.stdenv.isLinux;

  home.packages = with pkgs; [
    zoxide
    fzf
    wireshark
    libyaml
    ruby
    coreutils-full
    git-quick-stats
    gnumake
    inkscape
    gnumake
    cargo
    wl-clipboard
    qbittorrent
    tree
    zstd
    walk
    rsync
    watch
    tmux
    bmon
    nmap
    ncdu

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
    vesktop
    google-chrome
    feishin
    spotify
    neofetch
    jetbrains.idea-ultimate
    jetbrains.clion
    obsidian
    zotero
    signal-desktop
    prismlauncher
    git
    git-annex
    mpv
    ffmpeg
    darktable
    thunderbird
    kotlin
    dafny
    dotnet-sdk
    k9s
    kubectl
    minikube
    zoom-us
    wget
    cabextract
    podman
    ookla-speedtest
    iperf
    iperf2
    jellyfin-media-player
    python311Packages.pygments

    # Haskell
    ghc
    haskell-language-server
    haskellPackages.stack

    # JVM
    gradle
    scala
    metals
    coursier
    sbt
    scala-cli
    kotlin
  ]
  ++ (
    if stdenv.isDarwin then
      [
        pinentry_mac
        asitop
      ]
    else if stdenv.isLinux then
      [
        ethtool
        obs-studio
        pinentry-all
        gamescope
        makemkv
        whatsapp-for-linux
        popsicle
        powertop
        nerd-fonts.droid-sans-mono
        s-tui
        resilio-sync
        proton-pass
      ]
    else []
  );


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
    pinentryPackage =
      if pkgs.stdenv.isLinux then
        pkgs.pinentry-all
      else
        pkgs.pinentry_mac;
  };
}
