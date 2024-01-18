{lib, ...}: {
  imports = [./hardware-configuration.nix];

  config = {
    documentation.man.enable = false;

    time = {
      hardwareClockInLocalTime = true;
      timeZone = "Europe/Amsterdam";
    };

    hardware.opengl.enable = true;

    networking = {
      networkmanager.enable = true;

      hostName = lib.mkDefault "wodan";

      firewall = {
        enable = false;
      };
      useDHCP = lib.mkDefault true;
    };
    gui = {
      enable = true;
      desktop = {
        enable = true;
        rdp.enable = true;
      };
      apps.steam.enable = true;
      game-mode.enable = true;
      quiet-boot.enable = true;
    };

    traits = {
      hardware = {
        tpm.enable = true;
        secure-boot.enable = true;
        nvidia.enable = true;
      };
    };

    disks.btrfs = {
      enable = true;
      main = "/dev/disk/by-id/usb-CT120BX5_00SSD1_111122223333-0:0";
    encrypt=true;

};
    services.resilio = {
      enable = lib.mkForce false;
    };
    networking.firewall.enabled = mkForce false;
    boot = {
      initrd = {
        availableKernelModules = ["e1000e"];
        network =  {
          enable = true;
          ssh = {
            enable = true;
            port = 22;
            shell = "/bin/cryptsetup-askpass";
            authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMQkKn73qM9vjYIaFt94Kj/syd5HCw2GdpiZ3z5+Rp/r tomas@blue-fire"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4 tomas"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJRn81Pxfg4ttTocQnTUWirpC1QVeJ5bfPC63ET9fNVa root@blue-fire"
          "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBL68j0j9QNtaxySo9ysSV2n3xBcqc1aYzGFblwQvi1BQoQ4KIpCLkCxOx69yOdo/LwoCriyCmEEimqM0bEL3YZs="
          "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBOgjI9ptMC39vQC84tiNOgU8LBpI05KeiLtNGT465wCL/L3DYNLOdOP6KRqUvUBVTdZP3YACUa17LQu3taPGhfQ= ShellFish@iPhone-18012024"
          
                 ];
        hostKeys = ["/etc/secrets/initrd/ssh_host_ed25519_key"];
          };
        };
      };
      kernelParams = ["ip=dhcp"];
      
      
      loader = {
      efi = {
        canTouchEfiVariables = false;
        # efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        efiInstallAsRemovable = true;
      };
    };
    };
  };
}
