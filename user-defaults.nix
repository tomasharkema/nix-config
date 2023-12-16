{ lib, ... }: {
  time.timeZone = "Europe/Amsterdam";
  system.stateVersion = "23.11";
  security.sudo.wheelNeedsPassword = false;
  nixpkgs.config.allowUnfree = true;

  users = {
    mutableUsers = true;

    users = {
      root.password = lib.mkDefault "tomas";
      root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMQkKn73qM9vjYIaFt94Kj/syd5HCw2GdpiZ3z5+Rp/r tomas@supermicro"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4 tomas"
      ];
      tomas.password = lib.mkDefault "tomas";
      tomas.isNormalUser = true;
      tomas.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMQkKn73qM9vjYIaFt94Kj/syd5HCw2GdpiZ3z5+Rp/r tomas@supermicro"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4 tomas"
      ];
    };
    groups.tomas = {
      name = "tomas";
      members = [ "tomas" ];
      gid = 1666;
    };
  };
}
