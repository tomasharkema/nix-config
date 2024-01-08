{system ? builtins.currentSystem}: let
  flake = builtins.getFlake (toString ./.);
in
  with flake.inputs.nixpkgs.lib;
    mapAttrsToList (name: value: "nixosConfigurations." + name) flake.outputs.nixosConfigurations
