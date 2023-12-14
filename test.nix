{
  #   pkgs ? builtins.fetchTarball {
  #   url =
  #     "https://github.com/NixOS/nixpkgs-channels/archive/fce7562cf46727fdaf801b232116bc9ce0512049.tar.gz";
  #   sha256 = "sha256:14rvi69ji61x3z88vbn17rg5vxrnw2wbnanxb7y0qzyqrj7spapx";
  # } 
  pkgs ? import <nixpkgs> {
    overlays = [
      (self: super: {
        nix = super.nix.override {
          storeDir = "/mnt/nix/store";
          stateDir = "/mnt/nix/var";
        };
      })
    ];
  }
}:
pkgs.mkShell {

  buildInputs = [ pkgs.nix pkgs.nix-serve ];
  shellHook = ''
    set -x;
    export NIX_CONFIG='extra-substituters = http://tower.ling-lizard.ts.net:6666/ https://tomasharkema.cachix.org/ https://cache.nixos.org/';
    ${pkgs.nix-serve}/bin/nix-serve -p 6666
  '';
}
