{
  pkgs,
  inputs,
  ...
} @ attrs: let
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

  reencrypt = {system}:
    pkgs.writeShellScriptBin "reencrypt" ''
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
  remote-cli = import ./apps/remote-cli attrs;
  go = (import ./apps/go) attrs;
in
  pkgs.mkShell {
    name = "devshell";
    # nixpkgs.config.allowUnfree = true;
    allowUnfree = true;

    defaultPackage = pkgs.zsh;
    # buildInputs = [pkgs.home-manager];

    packages = with pkgs;
      [
        remote-cli
        (reencrypt {inherit system;})

        ack
        age
        inputs.attic.packages.${system}.default
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
      ]
      ++ (import ./packages/nixpkgs.nix attrs)
      ++ rundesk
      ++ go;
  }
