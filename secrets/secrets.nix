let
  tomas =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4";
  users = [ tomas ];

  enceladus =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICTiQQzh6t0sQabqkzyYpqA9zIgnA0we+nQVs54UG0ct";
  unraidferdorie =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMwFRuqkNmeyp6CHQTdOse0S4WasMElgrV+5lUFMX6y7";
  systems = [ enceladus unraidferdorie ];
  allKeys = users ++ systems;
in { "atuin.age".publicKeys = allKeys; }
