{
  lib,
  config,
  ...
}: {
  config = {
    assertions = [
      {
        assertion = false;
        message = ''
          Need this?
        '';
      }
    ];
    time.timeZone = "Europe/Amsterdam";
    system.stateVersion = "24.11";
    # security.sudo.wheelNeedsPassword = false;
    nixpkgs.config.allowUnfree = true;

    users = {
      mutableUsers = true;

      users = {
        root = {
          password = lib.mkDefault "tomas";
          # openssh.authorizedKeys.keys = [
          #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMQkKn73qM9vjYIaFt94Kj/syd5HCw2GdpiZ3z5+Rp/r tomas@blue-fire"
          #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4 tomas"
          #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJRn81Pxfg4ttTocQnTUWirpC1QVeJ5bfPC63ET9fNVa root@blue-fire"
          # ];
        };
        "${config.user.name}" = {
          password = lib.mkDefault "tomas";
          isNormalUser = true;
          # openssh.authorizedKeys.keys = [
          #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMQkKn73qM9vjYIaFt94Kj/syd5HCw2GdpiZ3z5+Rp/r tomas@blue-fire"
          #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4 tomas"
          #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJRn81Pxfg4ttTocQnTUWirpC1QVeJ5bfPC63ET9fNVa root@blue-fire"
          # ];
          extraGroups = ["video" "audio"];
        };
      };
      groups."${config.user.name}" = {
        name = "${config.user.name}";
        members = ["${config.user.name}"];
      };
    };
  };
}
