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
    "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel-no-zfs-installer.nix"
    ./installer.nix
    {
      nixpkgs = {
        hostPlatform.system = "aarch64-linux";
        buildPlatform.system = "x86_64-linux";
        # crossSystem.system = "aarch64-linux";
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
          sdImage = {firmwareSize = 4 * 1024;};

          boot.kernelParams = [
            # "console=ttyS0,115200n8"
            "console=ttyS1,115200"
          ];

          swapDevices = [
            {
              device = "/swapfile";
              size = 4 * 1024;
            }
          ];

          networking = {
            wireless.enable = false;

            networkmanager = {
              enable = true;
              ensureProfiles.profiles = {
                "iot" = {
                  connection = {
                    id = "iot";
                    interface-name = "wlan0";
                    type = "wifi";
                    uuid = "cfbdd233-4cd7-41b8-8c3d-302fb2bfbbe8";
                  };
                  ipv4 = {
                    method = "auto";
                  };
                  ipv6 = {
                    addr-gen-mode = "default";
                    method = "auto";
                  };
                  proxy = {};
                  wifi = {
                    mode = "infrastructure";
                    ssid = "iot";
                  };
                  wifi-security = {
                    auth-alg = "open";
                    key-mgmt = "wpa-psk";
                  };
                };
              };
            };
          };
          users.users.nixos.initialPassword = "calvin";
        };
      }
    )
  ];
}
