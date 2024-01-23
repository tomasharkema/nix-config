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
      set -e
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
    # environment.systemPackages = with pkgs; [dracut];

    boot = {
      crashDump.enable = true;
      initrd = {
        luks.devices."crypted" = {
          # keyFile = "/key/key";
          # tryEmptyPassphrase = true;
          # additionalKeyFiles = ["/key/key"];
        };

        secrets = {
          "/etc/tor/onion/bootup" = "/home/tomas/tor/onion"; # maybe find a better spot to store this.
        };

        # postDeviceCommands =
        # preLVMCommands = pkgs.lib.mkBefore ''
        #   look_for_usb() {
        #     info "looking for key file!"
        #     mkdir -m 0755 -p /key
        #     sleep 2 # To make sure the usb key has been loaded

        #     usbdevice="/dev/disk/by-partlabel/a7098897-2784-4776-bd3d-0e217d85963d"

        #     if mount -t vfat -o ro $usbdevice /key 2>/dev/null; then
        #         if [ -e /key/key ]; then

        #           device="$(cat /crypt-ramfs/device)"
        #           info "found key $device"

        #           passphrase="$(cat /key/key)"

        #           rm /crypt-ramfs/device
        #           echo -n "$passphrase" > /crypt-ramfs/passphrase

        #         fi
        #         umount /key
        #     fi
        #   }
        #   look_for_usb &
        # '';

        systemd = {
          initrdBin = [pkgs.ntp pkgs.tor pkgs.haveged];
          emergencyAccess = true;
          enable = true;
          users.root.shell = "/bin/systemd-tty-ask-password-agent";

          services.tor = {
            serviceConfig.Type = "oneshot";

            after = ["network-pre.target"];
            before = ["network.target"];

            script = let
              torRc = pkgs.writeText "tor.rc" ''
                DataDirectory /etc/tor
                SOCKSPort 127.0.0.1:9050 IsolateDestAddr
                SOCKSPort 127.0.0.1:9063
                HiddenServiceDir /etc/tor/onion/bootup
                HiddenServicePort 22222 127.0.0.1:22222
              '';
            in ''
              echo "tor: preparing onion folder"
              # have to do this otherwise tor does not want to start
              chmod -R 700 /etc/tor

              echo "make sure localhost is up"
              ip a a 127.0.0.1/8 dev lo
              ip link set lo up

              echo "tor: starting tor"
              tor -f ${torRc} --verify-config
              tor -f ${torRc} &
            '';
          };

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
        };

        availableKernelModules = ["e1000e" "r8169"];
        kernelModules = ["uas" "usbcore" "usb_storage" "vfat" "nls_cp437" "nls_iso8859_1"];

        network = {
          enable = true;
          flushBeforeStage2 = true;

          # udhcpc.enable = true;
          ssh = {
            enable = true;
            port = 22222;
            # shell = "/bin/cryptsetup-askpass";
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
