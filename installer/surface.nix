{
  inputs,
  channels,
}:
inputs.nixpkgs.lib.nixosSystem {
  system = "${channels.nixpkgs.system}";
  specialArgs = {
    inherit inputs;
  };
  modules = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
    ./installer.nix
    {
      nixpkgs = {
        # localSystem = "x86_64-linux"; # buildPlatform
        crossSystem = {
          config = "aarch64-unknown-linux-gnu";
        };

        config.allowUnsupportedSystem = true;
      };
    }
    (
      {
        lib,
        pkgs,
        ...
      }: {
        config = {
          # sdImage = {firmwareSize = 4 * 1024;};

          fileSystems = {
            "/boot/firmware" = {
              device = "/dev/disk/by-label/FIRMWARE";
              fsType = "vfat";
              options = [
                "noatime"
                "noauto"
                "x-systemd.automount"
                "x-systemd.idle-timeout=1min"
              ];
            };
          };

          boot = {
            # kernelParams = [
            #   "console=ttyS0,115200n8"
            #   "console=ttyS1,115200n8"
            #   "console=ttyAMA10,115200n8"
            # ];
            blacklistedKernelModules = ["qcom_q6v5_pas"];

            kernelPackages = lib.mkForce (pkgs.linuxPackagesFor (pkgs.buildLinux {
              version = "6.19";
              src = pkgs.fetchFromGitHub {
                owner = "jglathe";
                repo = "linux_ms_dev_kit";
                rev = "jg/ubuntu-qcom-x1e-6.19";
                hash = "";
              };
            }));

            loader = {
              generic-extlinux-compatible = {
                enable = lib.mkForce false;
              };

              systemd-boot = {
                enable = true;
              };
            };
          };

          hardware = {
            deviceTree = {
              enable = true;
              name = "qcom/x1p42100-microsoft-sp12.dts";
            };
            firmware = with pkgs; [
              inputs.self.packages.aarch64-linux.surface-pro-12-linux
              linux-firmware
              wireless-regdb
            ];
          };

          isoImage.forceTextMode = true;

          environment.systemPackages = with pkgs; [
            nixos-facter
            dtc
            raspberrypifw
            raspberrypi-eeprom
            device-tree_rpi
            inputs.self.packages.aarch64-linux.surface-pro-12-linux
          ];

          swapDevices = [
            {
              device = "/swapfile";
              size = 8 * 1024;
            }
          ];

          networking = {
            # wireless.enable = false;

            networkmanager = {
              enable = true;
            };
          };
          users.users.nixos.initialPassword = "calvin";
        };
      }
    )
  ];
}
