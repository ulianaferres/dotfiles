# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, modulesPath, ... }:

let
  zfsCompatibleKernelPackages = lib.filterAttrs (
    name: kernelPackages:
    (builtins.match "linux_[0-9]+_[0-9]+" name) != null
    && (builtins.tryEval kernelPackages).success
    && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
  ) pkgs.linuxKernel.packages;

  latestKernelPackage = lib.last (
    lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );
in
{
  imports =
    [ # Include the results of the hardware scan.
      (import ./hardware-configuration.nix { inherit config lib pkgs modulesPath; })
#      ./nixos_extra_modules/aes67-daemon.nix
    ];

  nixpkgs.config.allowUnfree = true;

  # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  environment.sessionVariables = { NIXOS_OZONE_WL = "1"; };
  # Useful other development tools

  boot.kernelPackages = latestKernelPackage;
#  nixpkgs.overlays = [
#    (final: prev: {
#      aes67-linux-daemon = final.callPackage ./pkgs/aes67-linux-daemon.nix {
#        kernel = latestKernelPackage.kernel;
#      };
#      aes67-linux-daemon-webui = final.callPackage ./pkgs/aes67-linux-daemon-webui.nix {};
#    })
#  ];

#  boot.kernelModules = [ "MergingRavennaALSA" ];
  boot.extraModulePackages = with pkgs; [
    #aes67-linux-daemon
  ];

  services.avahi = {
    enable = true;
    allowPointToPoint = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };

  networking.interfaces.enp6s0.ipv4.addresses = [ {
    address = "192.168.0.101";
    prefixLength = 24;
  } ];

#  services.aes67-daemon = {
#    enable = false;
#    interface = "enp7s0f0np0";
#    interface = "enp6s0";
#  };

  environment.systemPackages = with pkgs; [
    wireshark
    helvum
    linuxptp
    alsa-utils
    dive # look into docker image layers
    podman-tui # status of containers in the terminal
    docker-compose # start group of containers for dev
    #podman-compose # start group of containers for dev
    nvtopPackages.nvidia
    openrazer-daemon
    polychromatic
  ];


#  nixpkgs.config.allowUnfreePredicate = pkg:
#    builtins.elem (lib.getName pkg) [
#      "nvidia-x11"
#      "nvidia-settings"
#      "nvidia-persistenced"
#    ];

  nix = {
    package = pkgs.nixVersions.latest;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.extraModprobeConfig = ''
    options nvidia NVreg_PreserveVideoMemoryAllocations=1
    options nvidia NVreg_TemporaryFilePath=/var/tmp
  '';


  networking.hostId = "f3eff353";
  networking.hostName = "desktopalex"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";


  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.zsh;
    users.alex = {
      shell = pkgs.zsh;
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" "openrazer" ];
  #    packages = with pkgs; [
  #      tree
  #    ];
    };
  };

  programs = {
    sway.enable = true;
    steam.enable = true;
    zsh.enable = true;
  };  

  security.rtkit.enable = true;
  services = {
    openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        PasswordAuthentication = false;
        AllowedUsers = null;
        UseDns = true;
      };
    };
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      #pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
#      wireplumber.configPackages = [
#        (pkgs.writeTextDir "share/wireplumber/main.lua.d/99-alsa-aes67.lua" ''
#          alsa_monitor.rules = {
#            {
#              matches = {{{ "node.name", "matches", "alsa_output.*mergin_rav*" }}};
#            },
#          }
#        '')
#      ];
#      wireplumber.extraConfig."99-aes67-alsa" = {
#        "node.rules" = [{
#          matches = [ 
#            { "node.name" = "alsa_input.*"; }
#            #{ "device.name" = "alsa_card.aes67"; }
#          ];
#          actions = {
#            update-props = {
#              "api.alsa.pcm.device" = "AES67 Source";
#              "node.description" = "AES67 Source";
#              "media.class" = "Audio/Source";
#            };
#          };
#        }];
#      };
    };
    xserver = {
      enable = true;
      xkb.layout = "us";
      videoDrivers = [ "nvidia" ];
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
      desktopManager.gnome.enable = true;
    };
#    xserver = {
#      xkb.layout = "us";
#      videoDrivers = [ "nvidia" ];
#    };
#    desktopManager.plasma6 = {
#      enable = true;
#    };
#    displayManager = {
#      defaultSession = "plasma";
#      sddm = {
#        enable = true;
#        wayland.enable = true;
#      };
#    };
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
  };

  hardware.openrazer = {
    enable = true;
    users = [ "alex" ];
  };

  # programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}

