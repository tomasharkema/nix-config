{ pkgs, colmena, deploy-rs, home-manager }:
pkgs.mkShell {
  # imports = [ home-manager.nixosModules.default ];

  NIX_CONFIG = "extra-experimental-features = nix-command flakes repl-flake";
  nativeBuildInputs = [
    deploy-rs
    colmena
    pkgs.nixpkgs-fmt

    pkgs.nix
    pkgs.home-manager
    pkgs.git

    pkgs.sops
    pkgs.ssh-to-age
    pkgs.gnupg
    pkgs.age
  ];

}
