let
  tomas =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4";
  users = [ tomas ];

  enceladus =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICTiQQzh6t0sQabqkzyYpqA9zIgnA0we+nQVs54UG0ct root@enceladus";
  unraidferdorie =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMwFRuqkNmeyp6CHQTdOse0S4WasMElgrV+5lUFMX6y7";
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
  "tailscale.age".publicKeys = allKeys;
}
