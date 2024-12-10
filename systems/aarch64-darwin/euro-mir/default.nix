{pkgs, ...}: {
  config = {
    age = {
      identityPaths = ["/Users/tomas/.ssh/id_ed25519"];
      rekey = {
        hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4";
      };
    };
  };
}
