let
  tomas =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4";
      wsl =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKXJJrsfcYDGtfl8zQ1hjs+0UdasQLpO4ybFNlTqtjoI tomas@DESKTOP-L8N2UGE";
  users = [ tomas wsl ];

  enceladus =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICTiQQzh6t0sQabqkzyYpqA9zIgnA0we+nQVs54UG0ct root@enceladus";
  unraidferdorie =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFS0T53Bwn00Vqhc9GHD+RY78LIKfWvMo2rvQOvGW+lQ root@nixos";
  utm-nixos =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICgPvSzMf7TG4ArvFFp8R/kfj6XYXkMl3r47FL5voIBN root@utm-nixos";
  cfserve =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBb9arJaumjQJa7lnbVsabpSx41WHalIRIF+uH5tqlsJ";
  hyperv-nixos =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPpdAXhywLokEcCBpBA05V6Q8enw4ImVnHHX4Uf8StvF root@hyperv-nixos";

  systems = [ enceladus unraidferdorie utm-nixos cfserve hyperv-nixos ];
  allKeys = users ++ systems;
in {
  "atuin.age".publicKeys = allKeys;
  "atuin_session.age".publicKeys = allKeys;
  "tailscale.age".publicKeys = allKeys;
  "gh.age".publicKeys = allKeys;
  "resilio-p.age".publicKeys = allKeys;
  "resilio-docs.age".publicKeys = allKeys;
  "netdata.age".publicKeys = allKeys;
}
