{
  inputs,
  pkgs,
  lib,
  ...
}:
with pkgs;
with lib; let
  # attic-pkg = inputs.attic.packages.${system}.default;
  # agenix-pkg = inputs.agenix.packages.${system}.default;
  # deploy-rs-pkg = inputs.deploy-rs.packages.${system}.default;
  write-script = writeShellScriptBin "write-script" ''
    set -x
    echo "pv $1 $2"
    pv $1 -cN in -B 500M -pterbT | zstd -d - | pv -cN out -B 500M -pterbT > $2
  '';
  deployment = writeShellScriptBin "deployment" ''
    ${inputs.deploy-rs.packages.${system}.default}/bin/deploy --skip-checks --targets $@ -- --log-format internal-json -v |& ${nix-output-monitor}/bin/nom --json
  '';
  deploy-machine = writeShellScriptBin "deploy-machine" ''
    set -x
    ${inputs.deploy-rs.packages.${system}.default}/bin/deploy --skip-checks ".#$@" -- --log-format internal-json -v |& ${nix-output-monitor}/bin/nom --json
  '';
  reencrypt = writeShellScriptBin "reencrypt" ''
    set -x;
    cd secrets;
    ${inputs.agenix.packages.${system}.default}/bin/agenix -r
  '';
  mkiso = writeShellScriptBin "mkiso" ''
    LINK="./out/install.iso";
    nom build '.#nixosConfigurations.hyperv-nixos.config.formats.install-iso' --out-link $LINK
    pv $LINK -cN in -B 100M -pterbT | xz -T4 -9 | pv -cN out -B 100M -pterbT > ./out/install.iso.xz
  '';
  remote-deploy = writeShellScriptBin "remote-deploy" ''
    remote deployment '.#arthur' '.#enzian'
  '';
  nixpkgs = import ../../modules/home/tools/nix/nixpkgs.nix {inherit pkgs inputs;};
in
  mkShell {
    name = "devshell";
    allowUnfree = true;

    defaultPackage = zsh;
    # buildInputs = [pkgs.home-manager];

    # nix-profiler

    packages = with inputs;
      [
        alejandra
        ack
        age
        bash
        bfg-repo-cleaner
        colima
        comma
        deploy-machine
        deployment
        direnv
        git
        gnupg
        inputs.agenix.packages.${system}.default
        inputs.attic.packages.${system}.default
        inputs.deploy-rs.packages.${system}.default
        inputs.flake-checker.packages.${system}.default
        mkiso
        netdiscover
        nil
        pkgs.custom.remote-cli
        pkgs.custom.rundesk
        python3
        reencrypt
        remote-deploy
        sops
        ssh-to-age
        write-script
        zsh
      ]
      ++ nixpkgs;

    shellHook = ''
      git status
    '';
  }
