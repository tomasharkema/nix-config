{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib,
  # You also have access to your flake's inputs.
  inputs,
  # All other arguments come from NixPkgs. You can use `pkgs` to pull shells or helpers
  # programmatically or you may add the named attributes as arguments here.
  pkgs,
  stdenv,
  ...
}:
with pkgs; let
  write-script = writeShellScriptBin "write-script" ''
    set -x
    echo "pv $1 $2"
    pv $1 -cN in -B 500M -pterbT | zstd -d - | pv -cN out -B 500M -pterbT > $2
  '';

  deployment = writeShellScriptBin "deployment" ''
    ${deploy-rs}/bin/deploy --skip-checks --targets $@ -- --log-format internal-json -v |& ${nix-output-monitor}/bin/nom --json
  '';

  deploy-machine = writeShellScriptBin "deploy-machine" ''
    set -x
    ${deploy-rs}/bin/deploy --skip-checks ".#$@" -- --log-format internal-json -v |& ${nix-output-monitor}/bin/nom --json
  '';

  reencrypt = {system}:
    writeShellScriptBin "reencrypt" ''
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
  # rundesk = (import ./rundesk attrs).packages;
  # remote-cli = import ./apps/remote-cli attrs;
  # go = (import ./apps/go) attrs;
in
  mkShell {
    name = "devshell";
    # nixpkgs.config.allowUnfree = true;
    allowUnfree = true;

    defaultPackage = pkgs.zsh;
    # buildInputs = [pkgs.home-manager];

    packages =
      with pkgs;
      with inputs; [
        custom.remote-cli
        # (reencrypt {inherit system;})
        # nix-profiler

        ack
        age
        attic.packages.${system}.default
        bash
        bfg-repo-cleaner
        colima
        comma
        deploy-machine
        deploy-rs
        deployment
        git
        gnupg

        mkiso
        netdiscover
        python3
        remote-deploy
        sops
        ssh-to-age
        write-script
        zsh
        custom.rundesk
      ]
      # ++ (import ./packages/nixpkgs.nix attrs)
      #++ go;
      ;
  }
