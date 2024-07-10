{pkgs, ...}: {
  config = {
    age.rekey = {hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIICb4X+GYjcvvpjiRPhNdyqMyda6kFTkD9N4ZB2oOsEQ root@euro-mir-2";};
  };
}
