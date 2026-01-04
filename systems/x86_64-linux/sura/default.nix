{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = with inputs; [
    nixos-hardware.nixosModules.microsoft-surface-pro-intel
    nixos-hardware.nixosModules.microsoft-surface-common
  ];

  config = {
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    age = {
      rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMWmCzK3uR/xRwnff4s/7TkZ7CopG0zG9HH6qyCWZNUf root@sura";
    };

    disks.ext4 = {
      enable = true;
      main = "/dev/disk/by-id/ata-C400-MTFDDAT128MAM_0000000013050365897F";
    };

    environment.systemPackages = with pkgs; [
      cage
      custom.retro-adsb-radar
      firefox
    ];

    apps = {
      netdata.enable = lib.mkForce false;
    };

    gui.fonts.enable = true;

    services = {
      cage = {
        enable = true;
        user = "tomas";
        environment = {
          WLR_LIBINPUT_NO_DEVICES = "1";
          SDL_VIDEODRIVER = "wayland";
          MOZ_ENABLE_WAYLAND = "1";
        };
        # extraArguments = [
        #   "-s"
        #   "-D"
        #   "-d"
        # ];

        program = lib.getExe pkgs.custom.retro-adsb-radar;

        # program = pkgs.writeShellScript "radar" ''
        #   export WLR_LIBINPUT_NO_DEVICES=1
        #   export SDL_VIDEODRIVER=wayland
        #   export MOZ_ENABLE_WAYLAND=1
        #   exec ${lib.getExe pkgs.firefox} --kiosk --private-window https://adsb.ling-lizard.ts.net
        # '';
      };

      udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="drm", KERNEL=="card0", TAG+="systemd"
      '';

      remote-builders.client.enable = true;
      usbmuxd.enable = false;
      resilio.enable = lib.mkForce false;
      kmscon.enable = true;
      usbguard.enable = lib.mkForce false;
      tlp.enable = lib.mkForce false;
      netdata.enable = lib.mkForce false;
    };

    home-manager.users.tomas.dconf.settings = {
      "org/gnome/shell" = {
        disable-user-extensions = true;
      };
    };

    hardware.microsoft-surface.kernelVersion = "stable";
    # microsoft-surface = {
    # surface-control.enable = true;
    # };

    gui = {
      # enable = true;
      # desktop = {
      #   enable = true;
      # };
      # gnome = {
      #   enable = true;
      #   # hidpi.enable = true;export SDL_VIDEODRIVER=wayland
      # };
      # gamemode.enable = true;
      # quiet-boot.enable = true;
    };

    traits = {
      low-power.enable = true;
      hardware = {
        # tpm.enable = true;
        secure-boot.enable = true;
        laptop.enable = true;
        # intel.enable = true;
        bluetooth.enable = true;
      };
    };

    networking = {
      hostName = "sura"; # Define your hostname.
      networkmanager.enable = true;
      firewall = {
        enable = true;
      };
    };

    system = {
      etc.overlay.enable = true;
      nixos-init.enable = true;
    };
    services.userborn.enable = true;

    boot = {
      kernelPackages = lib.mkForce pkgs.linuxPackages_6_12;
      recovery = {
        enable = true;
        install = true;
        sign = true;
        netboot.enable = true;
      };

      kernelParams = ["mitigations=off"];
    };
  };
}
