{ config, ... }: {
  # config = {
  # nixpkgs.hostPlatform = "x86_64-linux";
  # targets.genericLinux.enable = true;
  # };

  # environment.persistence."/mnt/user/appdata/nix/persistent" = {
  # hideMounts = true;
  # directories = [
  # "/nix"
  # "/var/log"
  # "/var/lib/bluetooth"
  # "/var/lib/nixos"
  # "/var/lib/systemd/coredump"
  # "/etc/NetworkManager/system-connections"
  # {
  #   directory = "/var/lib/colord";
  #   user = "colord";
  #   group = "colord";
  #   mode = "u=rwx,g=rx,o=";
  # }
  # ];
  # files = [
  #   "/etc/machine-id"
  #   {
  #     file = "/etc/nix/id_rsa";
  #     parentDirectory = { mode = "u=rwx,g=,o="; };
  #   }
  # ];
  # users.tomas = {
  #   directories = [
  #     "Downloads"
  #     "Music"
  #     "Pictures"
  #     "Documents"
  #     "Videos"
  #     "VirtualBox VMs"
  #     {
  #       directory = ".gnupg";
  #       mode = "0700";
  #     }
  #     {
  #       directory = ".ssh";
  #       mode = "0700";
  #     }
  #     {
  #       directory = ".nixops";
  #       mode = "0700";
  #     }
  #     {
  #       directory = ".local/share/keyrings";
  #       mode = "0700";
  #     }
  #     ".local/share/direnv"
  #   ];
  #   files = [ ".screenrc" ];
  # };
  # };
}
