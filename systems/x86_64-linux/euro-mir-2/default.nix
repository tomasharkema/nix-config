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
    gui.enable = true;

    traits = {
      hardware = {
        tpm.enable = true;
        secure-boot.enable = true;
      };
    };

    # boot.loader.efi.efiSysMountPoint = "/boot/efi";
    # boot.loader.grub.efiSupport = true;
    # boot.loader.grub.efiInstallAsRemovable = true;
    # boot.loader.grub.device = "nodev";

    networking.hostName = "euro-mir-2"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networking.networkmanager.enable = true;

    powerManagement.enable = true;
    services.thermald.enable = true;

    # Enable CUPS to print documents.
    # services.printing.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.tomas = {
      isNormalUser = true;
      description = "tomas";
      extraGroups = ["networkmanager" "wheel"];
      packages = with pkgs; [
        firefox
        vscode
        # tilix
        # nvtop
        #  thunderbird
      ];
    };

    # nix.settings.experimental-features = ["nix-command" "flakes"];
    boot.loader.systemd-boot.enable = lib.mkForce false;
    #  boot.loader.systemd-boot.enable = true;
    #  boot.loader.systemd-boot.consoleMode = "auto";
    #  boot.loader.efi.canTouchEfiVariables = true;

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
    networking.firewall.enable = false;
  };
}
