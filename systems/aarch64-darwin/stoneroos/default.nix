{pkgs, ...}: {
  config = {
    age = {
      identityPaths = ["/Users/tomas/.ssh/id_ed25519"];
      rekey = {
        hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAUtJfbia+28OeSb1FHJoXPUSiBTLOYtk/bx26s1T3bC";
      };
    };
  };
}
