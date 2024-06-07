{ pkgs, inputs, lib, ... }:
with lib; {
  imports = with inputs;
    [
      nixos-hardware.nixosModules.raspberry-pi-4
      # "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel-no-zfs-installer.nix"
      # "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
    ];

  config = {
    services.udev.extraRules = ''
      # allow access to raspi cec device for video group (and optionally register it as a systemd device, used below)
      KERNEL=="vchiq", GROUP="video", MODE="0660", TAG+="systemd", ENV{SYSTEMD_ALIAS}="/dev/vchiq"
    '';

    # optional: attach a persisted cec-client to `/run/cec.fifo`, to avoid the CEC ~1s startup delay per command
    # scan for devices: `echo 'scan' > /run/cec.fifo ; journalctl -u cec-client.service`
    # set pi as active source: `echo 'as' > /run/cec.fifo`
    systemd = {
      sockets."cec-client" = {
        after = [ "dev-vchiq.device" ];
        bindsTo = [ "dev-vchiq.device" ];
        wantedBy = [ "sockets.target" ];
        socketConfig = {
          ListenFIFO = "/run/cec.fifo";
          SocketGroup = "video";
          SocketMode = "0660";
        };
      };

      services."cec-client" = {
        after = [ "dev-vchiq.device" ];
        bindsTo = [ "dev-vchiq.device" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.libcec}/bin/cec-client -d 1";
          ExecStop = ''/bin/sh -c "echo q > /run/cec.fifo"'';
          StandardInput = "socket";
          StandardOutput = "journal";
          Restart = "no";
        };
      };
    };

    networking = {
      hostName = "pegasus";
      firewall.enable = false;
      networkmanager.enable = true;
    };

    virtualisation.vmVariant = {
      virtualisation = {
        diskSize = 50 * 1024;
        memorySize = 4 * 1024;
        cores = 4;
      };
    };

    zramSwap = { enable = false; };
    swapDevices = [{
      device = "/swapfile";
      size = 16 * 1024;
    }];

    traits = {
      raspberry.enable = true;
      low-power.enable = true;
      hardware.bluetooth.enable = true;
    };

    gui."media-center".enable = true;

    apps = {
      # spotifyd.enable = true;
      cec.enable = true;
      unified-remote.enable = true;
      remote-builders.enable = true;
      netdata.enable = true;
    };

    environment.systemPackages = with pkgs; [
      libraspberrypi
      raspberrypi-eeprom
      ncspot
      libcec
      # pkgs.custom.playercast
    ];

    nix.settings = {
      keep-outputs = mkForce false;
      keep-derivations = mkForce false;
    };

    boot = {
      kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
      # kernelPackages = mkForce pkgs.linuxPackages_latest;
    };

    proxy-services = { enable = false; };

    hardware = {
      enableRedistributableFirmware = true;
      i2c.enable = true;

      bluetooth.package = pkgs.bluez;

      opengl = {
        enable = true;
        extraPackages = with pkgs; [ vaapiVdpau libvdpau-va-gl ];
        driSupport = true;
      };

      raspberry-pi."4" = {
        apply-overlays-dtmerge.enable = true;
        fkms-3d = {
          enable = true;
          # cma = 1024;
        };
        # dwc2 = {
        #   enable = true;
        #   dr_mode = "peripheral";
        # };
        # xhci.enable = true;
        # i2c0.enable = true;
        # audio.enable = true;
      };

      deviceTree = {
        enable = true;
        # filter = "bcm2711-rpi-4*.dtb";
        # filter = mkForce "*rpi-4-*.dtb";
      };
    };
  };
}
