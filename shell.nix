{ pkgs
, inputs
, nixpkgs
, ...
} @ attrs:

let
  inherit (pkgs) stdenv;
  write-script = pkgs.writeShellScriptBin "write-script" ''
    set -x
    echo "pv $1 $2"
    pv $1 -cN in -B 500M -pterbT | zstd -d - | pv -cN out -B 500M -pterbT > $2
  '';

  deployment = pkgs.writeShellScriptBin "deployment" ''
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

  mkiso = pkgs.writeShellScriptBin "mkiso" ''
    LINK="./out/install.iso";
    nom build '.#nixosConfigurations.hyperv-nixos.config.formats.install-iso' --out-link $LINK
    pv $LINK -cN in -B 100M -pterbT | xz -T4 -9 | pv -cN out -B 100M -pterbT > ./out/install.iso.xz
  '';

  remote-deploy = pkgs.writeShellScriptBin "remote-deploy" ''
    remote deployment '.#arthur' '.#enzian'
  '';

  rundesk = (import ./rundesk attrs).packages;


  hishtory = (pkgs.callPackage ./apps/hishtory {
    inherit (inputs.gomod2nix.legacyPackages.${pkgs.system}) buildGoApplication;
  });

in

pkgs.mkShell {
  name = "devshell";
  # nixpkgs.config.allowUnfree = true;
  allowUnfree = true;

  defaultPackage = pkgs.zsh;
  # buildInputs = [pkgs.home-manager];

  packages = with pkgs; [
    (import ./apps/remote-cli (attrs))
    (reencrypt { inherit system; })
    mkiso
    hishtory
    remote-deploy
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
  ] ++ (import ./packages/nixpkgs.nix (attrs)) ++ rundesk;
  # shellHook = ''
  #   export RD_TOKEN="9LczxcesPidTMTpPAK1LSoWdVYi9wixx"
  #   export RD_URL=https://rundeck.harkema.io
  #   # cachix use tomasharkema
  # '';
}
