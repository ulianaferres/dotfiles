# Alex's PC Configuration

Clone this repository directly to `~`, so that it is located at `~/dotfiles`.
Both NixOS and macOS configurations include home-manager as a module to ensure the entire system is consistent.

## For NixOS

```
sudo nixos-rebuild switch --flake ~/dotfiles#desktopalex
```

## For macOS

```
sudo darwin-rebuild switch --flake ~/dotfiles#macbookalex
```
