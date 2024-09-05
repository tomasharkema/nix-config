{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: {
  config = {
    age.rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDC7tNpEvVh4rd5ChYh2uTRK/cMRes21NW8HiZQc0vo5 root@test";
    };
  };
}
