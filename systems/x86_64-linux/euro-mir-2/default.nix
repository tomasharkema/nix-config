{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib,
  # An instance of `pkgs` with your overlays and packages applied is also available.
  pkgs,
  # You also have access to your flake's inputs.
  inputs,
  # Additional metadata is provided by Snowfall Lib.
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.
  # All other arguments come from the system system.
  config,
  ...
}: {
  imports = with inputs; [
    nixos-hardware.nixosModules.dell-xps-15-9560
    ./hardware-configuration.nix
  ];

  config = {
    disks.btrfs = {
      enable = true;
      main = "/dev/nvme0n1";
      # encrypt = true;
    };
    apps.attic.enable = true;
    gui = {
      enable = true;
      apps.steam.enable = true;
      game-mode.enable = true;
      quiet-boot.enable = true;
    };
    services.resilio.enable = lib.mkForce false;
    traits = {
      hardware = {
        tpm.enable = true;
        secure-boot.enable = true;
        laptop.enable = true;
        nvidia.enable = true;
      };
    };

    hardware.nvidia = {
      #   powerManagement.enable = true;
      #   powerManagement.finegrained = true;
      package = config.boot.kernelPackages.nvidiaPackages.production;
    };

    networking = {
      hostName = "euro-mir-2"; # Define your hostname.
      networkmanager.enable = true;
      wireless.enable = false;
      firewall.enable = true;
    };

    services = {
      xserver.libinput.enable = true;
      xserver.videoDrivers = ["nvidia" "intel"];
      tcsd.enable = lib.mkForce false;
    };

    boot = {
      binfmt.emulatedSystems = ["aarch64-linux"];
      # kernelPackages = pkgs.linuxPackages;
    };
    programs.mtr.enable = true;
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
  };
}
