{ pkgs, colmena, deploy-rs }:
pkgs.mkShell {
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
