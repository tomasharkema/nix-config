{pkgs, ...}: {
  config = {
    age = {
      #identityPaths = ["/Users/tomas/.ssh/id_ed25519"];
      rekey = {
        hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPBK6viwYczPwUY1ZseGDtR1Ptr7z7pGytMKO2dbKvXe tomas.harkema@Tomas-Harkema-CV404C72JJ";
      };
    };
  };
}
