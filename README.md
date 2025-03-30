# Alex's PC Configuration

Clone this repository directly to `~`, so that it is located at `~/.config`.


## For NixOS

The NixOS configuration includes home-manager as a module to ensure the entire system is consistent.
To build, run this in `~/.config`:
```
sudo nixos-rebuild switch --flake .#desktopalex
```

## For macOS

The macOS configuration declares home-manager as a standalone module.
To build, run:
```
home-manager switch
```
