{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.traits.hardware.remote-unlock;
in {
  options.traits = {
    hardware.remote-unlock = {
      enable = mkBoolOpt false "SnowflakeOS GNOME configuration";
    };
  };

  config = mkIf cfg.enable {
    system.activationScripts.remote-unlock-keys.text = ''
      set -ex
      mkdir -p /boot/secrets || true

      if [ ! -f "/boot/secrets/ssh_host_ecdsa_key" ]; then
        ${pkgs.openssh}/bin/ssh-keygen -t ecdsa -N "" -f /boot/secrets/ssh_host_ecdsa_key -q
      fi

      if [ ! -f "/boot/secrets/ssh_host_ed25519_key" ]; then
       ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -N "" -f /boot/secrets/ssh_host_ed25519_key -q
      fi

      if [ ! -f "/boot/secrets/ssh_host_rsa_key" ]; then
       ${pkgs.openssh}/bin/ssh-keygen -t rsa -N "" -f /boot/secrets/ssh_host_rsa_key -q
      fi
    '';
    environment.systemPackages = with pkgs; [dracut];

    boot = {
      initrd = {
        luks.devices."crypted" = {
          keyFile = "/key/key";
          # additionalKeyFiles = ["/key/key"];
        };

        extraUtilsCommands = ''
          copy_bin_and_libs ${pkgs.haveged}/bin/haveged
        '';

        verbose = true;

        # postDeviceCommands =
        preLVMCommands = pkgs.lib.mkBefore ''
          mkdir -m 0755 -p /key
          sleep 2 # To make sure the usb key has been loaded
          mount -n -t vfat -o ro /dev/disk/by-partlabel/a7098897-2784-4776-bd3d-0e217d85963d /key
        '';

        # systemd = {
        #   emergencyAccess = true;
        #   enable = true;
        #   users.root.shell = "/bin/systemd-tty-ask-password-agent";

        #   services.key-usb = {
        #     description = "Rollback BTRFS root subvolume to a pristine state";
        #     # wantedBy = [
        #     #   "initrd.target"
        #     # ];
        #     # after = [
        #     #   # LUKS/TPM process
        #     #   "systemd-cryptsetup@enc.service"
        #     # ];
        #     # before = [
        #     #   "sysroot.mount"
        #     # ];
        #     wantedBy = ["sysinit.target" "initrd.target"];
        #     before = ["cryptsetup-pre.target" "shutdown.target" "initrd-switch-root.service"];
        #     after = ["systemd-cryptsetup@enc.service"];

        #     unitConfig.DefaultDependencies = "no";
        #     serviceConfig.Type = "oneshot";

        #     script = ''
        #       mkdir -m 0755 -p /key
        #       sleep 2 # To make sure the usb key has been loaded
        #       mount -n -t vfat -o ro /dev/disk/by-partlabel/a7098897-2784-4776-bd3d-0e217d85963d /key
        #     '';
        #   };
        # };
        availableKernelModules = ["e1000e" "r8169"];
        kernelModules = ["uas" "usbcore" "usb_storage" "vfat" "nls_cp437" "nls_iso8859_1"];

        network = {
          enable = true;
          flushBeforeStage2 = true;
          # udhcpc.enable = true;
          ssh = {
            enable = true;
            port = 22222;
            shell = "/bin/cryptsetup-askpass";
            authorizedKeys = config.user.keys;
            hostKeys = [
              "/boot/secrets/ssh_host_ed25519_key"
              "/boot/secrets/ssh_host_rsa_key"
              "/boot/secrets/ssh_host_ecdsa_key"
            ];
          };
        };
      };
      kernelParams = ["ip=dhcp"];
    };
  };
}
