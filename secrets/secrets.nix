let
  tomas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4";
  # wsl =
  #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKXJJrsfcYDGtfl8zQ1hjs+0UdasQLpO4ybFNlTqtjoI tomas@DESKTOP-L8N2UGE";
  users = [ tomas ];

  enceladus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICTiQQzh6t0sQabqkzyYpqA9zIgnA0we+nQVs54UG0ct root@enceladus";
  unraidferdorie = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFS0T53Bwn00Vqhc9GHD+RY78LIKfWvMo2rvQOvGW+lQ root@nixos";
  utm-nixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICgPvSzMf7TG4ArvFFp8R/kfj6XYXkMl3r47FL5voIBN root@utm-nixos";
  cfserve = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHaCcdmZxFS197uAf7tBeAXV/RYl2WaShE9na67LyftQ root@cfserve";
  hyperv-nixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA74le7rZXdvB5aeET0Wy1JTn3fKonN+pAQPdPjVyzO8 root@hyperv-nixos";
  supermicro = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJRn81Pxfg4ttTocQnTUWirpC1QVeJ5bfPC63ET9fNVa root@supermicro";
  raspbii = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExHAekJ8mbudoEcFYJdJ58nSMyHFfNFrf84GIHuIeRY root@raspbii";
  winrtx-wsl = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICI2xzlzSsxv+6QSZ6rCeG0ma4HfIH3YWJj/P4GoQ3M/ root@nixos";
  raspbii3 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwd41uWPlgmaU6ckgFR3L4thPeKeIsaahHbjkg+qAOf root@raspbii3";
  systems = [ enceladus unraidferdorie utm-nixos cfserve hyperv-nixos supermicro raspbii raspbii3 ];
  allKeys = users ++ systems;
in
{
  "atuin-key.age".publicKeys = allKeys;
  "atuin-session.age".publicKeys = allKeys;
  "tailscale.age".publicKeys = allKeys;
  "gh.age".publicKeys = allKeys;
  "resilio-p.age".publicKeys = allKeys;
  "resilio-docs.age".publicKeys = allKeys;
  "netdata.age".publicKeys = allKeys;
  "resilio-shared-public.age".publicKeys = allKeys;
  "attic-key.age".publicKeys = allKeys;
}
