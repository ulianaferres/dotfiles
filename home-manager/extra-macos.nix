{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    skimpdf
    iterm2
    rectangle
    pinentry_mac
    asitop
  ];

  programs = {
    zsh.initContent = ''
      path+=('/Users/alex/.rustup/toolchains/stable-aarch64-apple-darwin/bin/')
    '';
  };
}
