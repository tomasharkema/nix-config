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
{ disks ? [ "/dev/vda" ], ... }:

{
  fileSystems."/persistent".neededForBoot = true;
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
            end = "-4G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/persistent";
            };
          };
          encryptedSwap = {
            size = "10M";
            content = {
              type = "swap";
              randomEncryption = true;
            };
          };
          plainSwap = {
            size = "100%";
            content = {
              type = "swap";
              resumeDevice = true; # resume from hiberation from this device
            };
          };
        };
      };
    };
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [ "size=2G" "defaults" "mode=755" ];
    };
  };

  environment.persistence."/persistent" = {
    # hideMounts = true;
    directories = [
      "/nix"
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      {
        directory = "/var/lib/colord";
        user = "colord";
        group = "colord";
        mode = "u=rwx,g=rx,o=";
      }
    ];
    files = [
      "/etc/machine-id"
      {
        file = "/etc/nix/id_rsa";
        parentDirectory = { mode = "u=rwx,g=,o="; };
      }
    ];
    users.tomas = {
      directories = [
        "Downloads"
        "Music"
        "Pictures"
        "Documents"
        "Videos"
        "VirtualBox VMs"
        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }
        {
          directory = ".nixops";
          mode = "0700";
        }
        {
          directory = ".local/share/keyrings";
          mode = "0700";
        }
        ".local/share/direnv"
      ];
      files = [ ".screenrc" ];
    };
  };
}
