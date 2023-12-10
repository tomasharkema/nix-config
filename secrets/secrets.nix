let
  tomas =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4";
  users = [ tomas ];

  enceladus =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICTiQQzh6t0sQabqkzyYpqA9zIgnA0we+nQVs54UG0ct";
  unraidferdorie =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMwFRuqkNmeyp6CHQTdOse0S4WasMElgrV+5lUFMX6y7";

  utm-nixos =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAkK+Gxr2deKsU/VOz84aRTzCgdxjPUYDhMoBj7bkb3p";

  cfserve =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBb9arJaumjQJa7lnbVsabpSx41WHalIRIF+uH5tqlsJ";

  systems = [ enceladus unraidferdorie utm-nixos cfserve ];
  allKeys = users ++ systems;
in {
  "atuin.age".publicKeys = allKeys;
  "tailscale.age".publicKeys = allKeys;
}
