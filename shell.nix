{ pkgs, colmena, deploy-rs, ... }@inputs:
pkgs.mkShell {
  # defaultPackage = pkgs.nix-tree;
  buildInputs = [ pkgs.home-manager ];
  packages = with pkgs; [
    home-manager
    nix-tree
    nixpkgs-fmt
    git
    zsh
    sops
    ssh-to-age
    gnupg
    age
    cachix
    nix
    deploy-rs
    colmena
    python3
    go
    gotools
    gopls
    go-outline
    gocode
    gopkgs
    gocode-gomod
    godef
    golint
    netdiscover
    ssh-to-age
    gnupg
    age
  ];
  shellHook = ''
    cachix use tomasharkema
    alias encrypt_keys='TEMP_DIR=$(mktemp -d); op read "op://Private/tomas-new/private_key?ssh-format=OpenSSH" --out-file $TEMP_DIR/id_ed25519; cd secrets; agenix -r -i $TEMP_DIR/id_ed25519; rm -rf $TEMP_DIR'
  '';
}
