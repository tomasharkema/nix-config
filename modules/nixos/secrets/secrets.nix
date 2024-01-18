let
  tomas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4";
  # wsl =
  #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKXJJrsfcYDGtfl8zQ1hjs+0UdasQLpO4ybFNlTqtjoI tomas@DESKTOP-L8N2UGE";
  users = [tomas];

  enzian = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN9/iOb/hw6R31UsX5b8VDq6aJEgn8M4k0Ow2IGY1qQb root@enzian";
  # enzian-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBkD6Gv2OmfofzWqPihWEo2mfOWx7kFkCh5urGNn/AJ0 tomas@enzian";

  silver-star-vm = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMjK+FEkEbBnaQZ/SgBaN0tniY2vKgx3049sf7sBH46y root@silver-star-vm";

  utm-nixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICgPvSzMf7TG4ArvFFp8R/kfj6XYXkMl3r47FL5voIBN root@utm-nixos";

  arthur = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE9VGnHYMX6qQ7cKCIHPDTp7ELCWURGSau97PHq/tn/y root@arthur";

  hyperv-nixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA74le7rZXdvB5aeET0Wy1JTn3fKonN+pAQPdPjVyzO8 root@hyperv-nixos";

  blue-fire = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDLZtRNaxKQwzBfC7xCjUgFl8/Zgg2dRLN6EIvx3wifh root@blue-fire";
  blue-fire-tomas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICOBloItNNcnAjlcBux/BJU0Dl9rry3SgR3VtGPK5LC6 tomas@blue-fire";

  pegasus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILovRLhj82nq2kK2KbydAxhLJs0RORJ6p33K3Z7rJlSA root@pegasus";

  wodan = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOf9/nugPzUtMCbSZwLIaRcB+Vc+gB0yCgGjRYemtRJd root@wodan";
  wodan-wsl = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICI2xzlzSsxv+6QSZ6rCeG0ma4HfIH3YWJj/P4GoQ3M/ root@wodan-wsl";
  wodan-wsl-tomas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICI2xzlzSsxv+6QSZ6rCeG0ma4HfIH3YWJj/P4GoQ3M/ root@nixos";

  baaa-express = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIehvj2mj3tzsYoZbwSZoBi0K7Yt1ElbOd+e9DR8P2Z root@baaa-express";
  baaa-express-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBzNmvr4dGWHPZ/ZoFN2wIzUSDhYO2+hq4r4FeAqIPSf tomas@baaa-express";

  euro-mir-2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGqH26JOhArILMf2cgHdUUuvyf3U7rAS6jGZykLYqjWe root@euro-mir-2";
  euro-mir-2-tomas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFDJQj15J+PmzFyX1jWRDmv2BzdWnEuU47kkMKg3q4QD tomas@euro-mir-2";
  euro-mir-vm = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICW+aQs9V+gOAWN5t8g8OYFNjdTkgDFagObW+unt7TMa root@euro-mir-vm";

  systems = [
    enzian
    # enzian-user
    silver-star-vm
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
  builders = [tomas blue-fire blue-fire-tomas];
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
  "ght.age".publicKeys = builders;
  "ght-runner.age".publicKeys = builders;
  "cachix.age".publicKeys = allKeys;
  "cachix-agent.age".publicKeys = allKeys;
  "cachix-activate.age".publicKeys = allKeys;
  "otp.age".publicKeys = allKeys;
  "ldap.age".publicKeys = builders;
  "healthcheck.age".publicKeys = allKeys;
}
