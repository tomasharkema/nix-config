{ pkgs
, inputs
, nixpkgs
, ...
} @ attrs:

let
  write-script = pkgs.writeShellScriptBin "write-script" ''
    set -x
    echo "pv $1 $2"
    pv $1 -cN in -B 500M -pterbT | zstd -d - | pv -cN out -B 500M -pterbT > $2
  '';

  deployment = pkgs.writeShellScriptBin "deployment" ''
    set -x
    ${pkgs.deploy-rs}/bin/deploy --skip-checks --targets $@ -- --log-format internal-json -v |& ${pkgs.nix-output-monitor}/bin/nom --json
  '';

  deploy-machine = pkgs.writeShellScriptBin "deploy-machine" ''
    set -x
    ${pkgs.deploy-rs}/bin/deploy --skip-checks ".#$@" -- --log-format internal-json -v |& ${pkgs.nix-output-monitor}/bin/nom --json
  '';

  reencrypt = { system }: pkgs.writeShellScriptBin "reencrypt" ''
    set -x;
    cd secrets; 
    ${inputs.agenix.packages.${system}.default}/bin/agenix -r
  '';

  mkiso = { ... }: pkgs.writeShellScriptBin "mkiso" ''
    LINK="./out/install.iso";
    nom build '.#nixosConfigurations.hyperv-nixos.config.formats.install-iso' --out-link $LINK
    pv $LINK -cN in -B 100M -pterbT | xz -T4 -9 | pv -cN out -B 100M -pterbT > ./out/install.iso.xz
  '';
in

pkgs.mkShell {
  defaultPackage = pkgs.zsh;
  # buildInputs = [pkgs.home-manager];

  packages = with pkgs; [
    (reencrypt { inherit system; })
    (mkiso { })
    inputs.attic.packages.${system}.default
    inputs.nix-cache-watcher.packages.${system}.nix-cache-watcher
    deploy-machine
    bfg-repo-cleaner
    ack
    age
    bash
    colmena
    comma
    deploy-rs
    deployment
    git
    gnupg

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
    python3
    sops
    ssh-to-age
    write-script
    zsh
    colima
    colmena
  ] ++ (import ./packages/nixpkgs.nix (attrs));
  # shellHook = ''
  #   # cachix use tomasharkema
  # '';
}
