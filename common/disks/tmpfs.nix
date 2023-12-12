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
  disko.devices = {
    disk = {
      vdb = {
        device = builtins.elemAt disks 0;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "500M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            nix = {
              size = "50G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/nix";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/media";
              };
            };
          };
        };
      };
    };
    nodev = {
      "/" = {
        fsType = "tmpfs";
        mountOptions = [ "size=3G" "mode=755" ];
      };
      "/home/username" = {
        fsType = "tmpfs";
        mountOptions = [ "size=3G" "mode=755" ];
      };
    };
  };
}
