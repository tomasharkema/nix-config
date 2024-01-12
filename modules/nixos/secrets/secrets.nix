let
  tomas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4";
  # wsl =
  #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKXJJrsfcYDGtfl8zQ1hjs+0UdasQLpO4ybFNlTqtjoI tomas@DESKTOP-L8N2UGE";
  users = [tomas];

  enzian = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBKRvC/NAq7GHn4OGGtk+pJvlJoPmdw0F57hf7EhJ0hpzhwroyo7rg/eO9V/7FAeWz/66K8gJIjxTiMfzWCwSQFk=";
  # enzian-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBkD6Gv2OmfofzWqPihWEo2mfOWx7kFkCh5urGNn/AJ0 tomas@enzian";

  silver-star-ferdorie = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFS0T53Bwn00Vqhc9GHD+RY78LIKfWvMo2rvQOvGW+lQ root@nixos";
  utm-nixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICgPvSzMf7TG4ArvFFp8R/kfj6XYXkMl3r47FL5voIBN root@utm-nixos";

  arthur = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE9VGnHYMX6qQ7cKCIHPDTp7ELCWURGSau97PHq/tn/y root@arthur";

  hyperv-nixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA74le7rZXdvB5aeET0Wy1JTn3fKonN+pAQPdPjVyzO8 root@hyperv-nixos";

  blue-fire = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDLZtRNaxKQwzBfC7xCjUgFl8/Zgg2dRLN6EIvx3wifh root@blue-fire";
  blue-fire-tomas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICOBloItNNcnAjlcBux/BJU0Dl9rry3SgR3VtGPK5LC6 tomas@blue-fire";

  pegasus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKAAuNlVlLPxJxxO66tc4o687Sqs0y5MiHOuTJwOZzE8 root@pegasus";

  wodan = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKBPi/cVDs9er8g5LJuGoz+xoUGDoiNIF7w1Blb9zTU9 root@wodan";
  wodan-wsl = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICI2xzlzSsxv+6QSZ6rCeG0ma4HfIH3YWJj/P4GoQ3M/ root@wodan-wsl";
  wodan-wsl-tomas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICI2xzlzSsxv+6QSZ6rCeG0ma4HfIH3YWJj/P4GoQ3M/ root@nixos";

  baaa-express = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIehvj2mj3tzsYoZbwSZoBi0K7Yt1ElbOd+e9DR8P2Z root@baaa-express";
  baaa-express-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBzNmvr4dGWHPZ/ZoFN2wIzUSDhYO2+hq4r4FeAqIPSf tomas@baaa-express";

  euro-mir-2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIABfvsZLVNnnTjq3Ms7AmCR+UD2HF6y1fjt8wxJ7FiAF root@euro-mir-2";
  euro-mir-2-tomas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFDJQj15J+PmzFyX1jWRDmv2BzdWnEuU47kkMKg3q4QD tomas@euro-mir-2";
  euro-mir-vm = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJHZOQbqiEFRhtymCd/UlbO8Y9Ti7afH5NKe7jGY1E70 root@euro-mir-vm";

  systems = [
    enzian
    # enzian-user
    silver-star-ferdorie
    utm-nixos
    arthur
    hyperv-nixos
    blue-fire
    blue-fire-tomas
    pegasus
    baaa-express
    baaa-express-user
    wodan
    wodan-wsl
    wodan-wsl-tomas
    euro-mir-2
    euro-mir-2-tomas
    euro-mir-vm
  ];
  allKeys = users ++ systems;
in {
  "atuin.age".publicKeys = allKeys;
  "tailscale.age".publicKeys = allKeys;
  "gh.age".publicKeys = allKeys;
  "resilio-p.age".publicKeys = allKeys;
  "resilio-docs.age".publicKeys = allKeys;
  "netdata.age".publicKeys = allKeys;
  "resilio-shared-public.age".publicKeys = allKeys;
  "attic-key.age".publicKeys = allKeys;
  "wireless.age".publicKeys = allKeys;
  "keybase.age".publicKeys = allKeys;
  "ght.age".publicKeys = [tomas blue-fire blue-fire-tomas];
  "ght-runner.age".publicKeys = [tomas blue-fire blue-fire-tomas];
  "cachix.age".publicKeys = allKeys;
  "cachix-agent.age".publicKeys = allKeys;
  # "cachix-activate.age".publicKeys = allKeys;
  "otp.age".publicKeys = allKeys;
}
