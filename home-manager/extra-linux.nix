{ config, pkgs, ... }:

{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
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
  ];

  programs = {
    firefox.enable = true;
    plasma = {
      enable = true;

      workspace = {
        clickItemTo = "select";
        lookAndFeel = "org.kde.breezedark.desktop";
      };
    };
  };
}
