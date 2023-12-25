let
  tomas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4";
  # wsl =
  #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKXJJrsfcYDGtfl8zQ1hjs+0UdasQLpO4ybFNlTqtjoI tomas@DESKTOP-L8N2UGE";
  users = [tomas];

  enzian = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICTiQQzh6t0sQabqkzyYpqA9zIgnA0we+nQVs54UG0ct root@enzian";
  enzian-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFfJzGCnEFkPB6jeyNgWC1+32w6X6JOwWnC+xqTiPYAw tomas@enzian";
  silver-star-ferdorie = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFS0T53Bwn00Vqhc9GHD+RY78LIKfWvMo2rvQOvGW+lQ root@nixos";
  utm-nixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICgPvSzMf7TG4ArvFFp8R/kfj6XYXkMl3r47FL5voIBN root@utm-nixos";

  arthur = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHaCcdmZxFS197uAf7tBeAXV/RYl2WaShE9na67LyftQ root@arthur";
  hyperv-nixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA74le7rZXdvB5aeET0Wy1JTn3fKonN+pAQPdPjVyzO8 root@hyperv-nixos";
  blue-fire = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJRn81Pxfg4ttTocQnTUWirpC1QVeJ5bfPC63ET9fNVa root@blue-fire";
  blue-fire-tomas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIe7xWdOnSC7EcDSX1GzDXy9HN8EINrx45EpCye2A+ya tomas@blue-fire";
  pegasus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKAAuNlVlLPxJxxO66tc4o687Sqs0y5MiHOuTJwOZzE8 root@pegasus";
  wodan-wsl = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICI2xzlzSsxv+6QSZ6rCeG0ma4HfIH3YWJj/P4GoQ3M/ root@nixos";

  baaa-express = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIehvj2mj3tzsYoZbwSZoBi0K7Yt1ElbOd+e9DR8P2Z root@baaa-express";
  baaa-express-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBzNmvr4dGWHPZ/ZoFN2wIzUSDhYO2+hq4r4FeAqIPSf tomas@baaa-express";

  systems = [enzian enzian-user silver-star-ferdorie utm-nixos arthur hyperv-nixos blue-fire pegasus baaa-express];
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
}
