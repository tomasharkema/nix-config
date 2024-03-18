let
  tomas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4";
  # wsl =
  #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKXJJrsfcYDGtfl8zQ1hjs+0UdasQLpO4ybFNlTqtjoI tomas@DESKTOP-L8N2UGE";
  users = [tomas];

  euro = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4";

  enzian = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFWBSBsCepulXWmLkxCirZ0yv0BXXSHB3/iq2NFkHBxs root@enzian";
  # enzian-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBkD6Gv2OmfofzWqPihWEo2mfOWx7kFkCh5urGNn/AJ0 tomas@enzian";

  silver-star-vm = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILZP/NhYd8ZBJBXDEDwUgkxQHEBD3DT2KsAQA3bn1MSC root@silver-star-vm";

  utm-nixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICgPvSzMf7TG4ArvFFp8R/kfj6XYXkMl3r47FL5voIBN root@utm-nixos";

  arthur = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ0N7wvhwFkccHR5bVQUC47H/Rb4asO3emf//Ut9cx0Q root@arthur";

  hyperv-nixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA74le7rZXdvB5aeET0Wy1JTn3fKonN+pAQPdPjVyzO8 root@hyperv-nixos";

  blue-fire = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDLZtRNaxKQwzBfC7xCjUgFl8/Zgg2dRLN6EIvx3wifh root@blue-fire";
  blue-fire-tomas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICOBloItNNcnAjlcBux/BJU0Dl9rry3SgR3VtGPK5LC6 tomas@blue-fire";

  pegasus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP7/aLVysb4kgpygwqQj2o7ys890bMcTxIPvswZ6oOHY root@pegasus";

  wodan = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHIiiOI9vP4fmNE+OTS+cPuoSysCwJVNQxQYSRgLYWX/ root@wodan";
  wodan-wsl = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICI2xzlzSsxv+6QSZ6rCeG0ma4HfIH3YWJj/P4GoQ3M/ root@wodan-wsl";
  wodan-wsl-tomas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICI2xzlzSsxv+6QSZ6rCeG0ma4HfIH3YWJj/P4GoQ3M/ root@nixos";

  baaa-express = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILU+xGIfTfinOqUhBs/7tdzuKRl5XRC7dyCzcWqxRZ7H root@baaa-express";
  baaa-express-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBzNmvr4dGWHPZ/ZoFN2wIzUSDhYO2+hq4r4FeAqIPSf tomas@baaa-express";

  euro-mir-2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIICb4X+GYjcvvpjiRPhNdyqMyda6kFTkD9N4ZB2oOsEQ root@euro-mir-2";
  euro-mir-2-tomas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMIZkviD01zlP3SkumEXHgLaNuoQxHqHPuBWcOqrm9rr tomas@euro-mir-2";
  euro-mir-vm = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII9jQFlABagOAqiRKUrk1k2Rw/U1BDbsfWmoz0+wO2Pz root@euro-mir-vm";

  schweizer-bobbahn = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJvt0ljBDmSkU8roLq9XULxQ14MLEtfm/GmXDFkw663Q root@schweizer-bobbahn";

  systems = [
    euro
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
    schweizer-bobbahn
  ];
  allKeys = users ++ systems;
  builders = [tomas blue-fire blue-fire-tomas];
in {
  "attic-key.age".publicKeys = allKeys;
  "attic-config.toml.age".publicKeys = allKeys;
  "atuin.age".publicKeys = allKeys;
  "binary-caches.json.age".publicKeys = allKeys;
  "cachix-activate.age".publicKeys = allKeys;
  "cachix-agent.age".publicKeys = allKeys;
  "cachix-token.age".publicKeys = allKeys;
  "cachix.age".publicKeys = allKeys;
  "command-center.env.age".publicKeys = allKeys;
  "gh.age".publicKeys = allKeys;
  "ght-runner.age".publicKeys = builders;
  "ght.age".publicKeys = builders;
  "healthcheck.age".publicKeys = allKeys;
  # "hercules-cli.key.age".publicKeys = allKeys;
  "keybase.age".publicKeys = allKeys;
  "ldap.age".publicKeys = builders;
  "mak.age".publicKeys = allKeys;
  "netdata.age".publicKeys = allKeys;
  "notify.age".publicKeys = allKeys;
  "op.age".publicKeys = allKeys;
  "otp.age".publicKeys = allKeys;
  # "peerix.private.age".publicKeys = allKeys;
  # "peerix.public.age".publicKeys = allKeys;
  "resilio-docs.age".publicKeys = allKeys;
  "resilio-p.age".publicKeys = allKeys;
  "resilio-shared-public.age".publicKeys = allKeys;
  "spotify-tui.age".publicKeys = allKeys;
  "tailscale.age".publicKeys = allKeys;
  "wireless.age".publicKeys = allKeys;
  "config.zerotier.settings.age".publicKeys = allKeys;
  "domainjoin.age".publicKeys = allKeys;
}
