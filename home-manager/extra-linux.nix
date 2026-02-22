{ config, pkgs, ... }:

{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    mission-center
    ethtool
    obs-studio
    pinentry-all
    gamescope
    makemkv
    popsicle
    powertop
    s-tui
    resilio-sync
    proton-pass
    wl-clipboard
    gimp
  ];

  programs = {
    plasma = {
      enable = true;

      workspace = {
        clickItemTo = "select";
        lookAndFeel = "org.kde.breezedark.desktop";
      };

      hotkeys.commands."launch-kitty" = {
        name = "Launch Kitty";
        key = "Meta+Return";
        command = "kitty";
      };
    };
  };
}
