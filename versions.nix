let
  flake = builtins.getFlake "${toString ./.}";
  pkgs = flake.pkgs."${builtins.currentSystem}".nixpkgs;
  lib = pkgs.lib;
  customPkgs = flake.packages."${builtins.currentSystem}";
in
  builtins.map (pkg: let
    repo = pkg.src.gitRepoUrl or "";
  in
    if lib.strings.hasPrefix "https://github.com" repo
    then rec {
      inherit repo;
      name = pkg.name;
      rev = pkg.src.rev or null;
      homepage = pkg.src.meta.homepage or null;
      position = pkg.src.meta.position or null;
      gh =
        #builtins.fromJSON (builtins.readFile
        pkgs.runCommand "${name}-gh-release-list-head" {
          GH_TOKEN = builtins.getEnv "GH_TOKEN";
          buildInputs = [pkgs.gh pkgs.jq];
        } ''
          echo ${name}
          # ${pkgs.gh}/bin/gh auth login
          ${pkgs.gh}/bin/gh release list --json name,tagName -R ${repo} | jq -r '.[0]' | tee $out
        ''; #);
    }
    else null) (builtins.attrValues customPkgs)
