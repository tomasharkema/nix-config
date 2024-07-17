{pkgs, ...}: {
  config = {
    age = {
      identityPaths = ["/Users/tomas/.ssh/id_ed25519"];
      rekey = {
        hostPubkey = "/Users/tomas/.ssh/id_ed25519.pub";
      };
    };
  };
}
