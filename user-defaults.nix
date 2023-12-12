{ ... }: {
  users = {
    mutableUsers = true;

    users = {
      # root.password = "tomas";
      root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4 tomas"
      ];
      # tomas.password = "tomas";
      tomas.isNormalUser = true;
      tomas.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4 tomas"
      ];
    };
  };
}
