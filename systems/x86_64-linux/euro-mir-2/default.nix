{
  pkgs,
  inputs,
  ...
}: {
  imports = with inputs; [
    nixos-hardware.nixosModules.dell-xps-15-9560-nvidia
    ./hardware-configuration.nix
  ];

  config = {
    disks.btrfs = {
      enable = true;
      main = "/dev/nvme0n1";
      encrypt = true;
    };

    gui = {
      enable = true;
      desktop = {
        enable = true;
      };
      gnome.enable = true;
      apps.steam.enable = true;
      # game-mode.enable = true;
      quiet-boot.enable = true;
    };

    services.fprintd = {
      enable = true;
      package = pkgs.fprintd-tod;
      tod = {
        enable = true;
        driver = pkgs.libfprint-2-tod1-goodix;
      };
    };

    environment.systemPackages = [pkgs.libfprint-2-tod1-goodix pkgs.libfprint-2-tod1-goodix-550a];

    # virtualisation.virtualbox.host.enableWebService = true;
    virtualisation.virtualbox.host.enable = true;

    apps.podman.enable = true;

    traits = {
      hardware = {
        tpm.enable = true;
        secure-boot.enable = true;
        laptop.enable = true;
        nvidia.enable = true;
        # remote-unlock.enable = true;
      };
    };

    networking = {
      hostName = "euro-mir-2"; # Define your hostname.
      networkmanager.enable = true;
      # wireless.enable = false;
      # firewall.enable = true;
    };

    services = {
      xserver.libinput.enable = true;
      # tcsd.enable = false;
    };

    boot = {
      # binfmt.emulatedSystems = ["aarch64-linux"];
      # kernelPackages = pkgs.linuxPackages;
      # blacklistedKernelModules = ["i915"];
      # kernelParams = ["acpi_rev_override=1"];
    };
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
  };
}
