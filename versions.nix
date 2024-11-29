let
  flake = builtins.getFlake "${toString ./.}";
  pkgs = flake.packages."${builtins.currentSystem}";
in
  builtins.map (pkg: {
    name = pkg.name;
    rev = pkg.src.rev or null;
    repo = pkg.src.gitRepoUrl or null;
    homepage = pkg.src.meta.homepage or null;
    position = pkg.src.meta.position or null;
  }) (builtins.attrValues pkgs)
