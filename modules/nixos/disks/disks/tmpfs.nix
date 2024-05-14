# fileSystems."/" =
#   { device = "none";
#     fsType = "tmpfs";
#     options = [ "size=3G" "mode=755" ]; # mode=755 so only root can write to those files
#   };
# fileSystems."/home/username" =
#   { device = "none";
#     fsType = "tmpfs";  # Can be stored on normal drive or on tmpfs as well
#     options = [ "size=4G" "mode=777" ];
#   };
# fileSystems."/nix" =  # can be LUKS encrypted
#   { device = "/dev/disk/by-uuid/UUID";
#     fsType = "ext4";
#   };
# fileSystems."/boot" =
#   { device = "/dev/disk/by-uuid/UUID";
#     fsType = "vfat";
#   };
{ disks ? [ "/dev/vda" ], ... }: {
  fileSystems."/nix".neededForBoot = true;
  disko.devices = {
    disk.main = {
      device = builtins.elemAt disks 0;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "1M";
            type = "EF02"; # for grub MBR
          };
          ESP = {
            name = "ESP";
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          nix = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/nix";
            };
          };
          # encryptedSwap = {
          #   size = "10M";
          #   content = {
          #     type = "swap";
          #     randomEncryption = true;
          #   };
          # };
          # plainSwap = {
          #   size = "100%";
          #   content = {
          #     type = "swap";
          #     resumeDevice = true; # resume from hiberation from this device
          #   };
          # };
        };
      };
    };
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [ "size=2G" "defaults" "mode=755" ];
    };
  };
}
