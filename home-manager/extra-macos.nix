{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    skimpdf
    iterm2
    rectangle
    pinentry_mac
    #asitop
  ];
}
