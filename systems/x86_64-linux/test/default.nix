{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
with lib; {
  config = {
    age.rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK0wmN/Cr3JXqmLW7u+g9pTh+wyqDHpSQEIQczXkVx9q root@test";
    };
  };
}
