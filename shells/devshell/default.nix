{
  inputs,
  pkgs,
  lib,
  ...
} @ attrs:
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

  diffs = import ../diffs attrs;
  packages-json = diffs.packages-json;
  # gum = lib.getExe pkgs.gum;
  # packages-json = writeShellScriptBin "packages-json" ''
  #   export DIR="$(mktemp -d)"

  #   SYSTEM_PKGS=".#$1.config.environment.systemPackages"
  #   # gum spin --spinner line --title "Evaluating $SYSTEM_PKGS to $DIR/first.json" --
  #   nix eval "$SYSTEM_PKGS" --json | tee "$DIR/first.json"

  #   HOME_PKGS=".#$1.config.home-manager.users.tomas.home.packages"
  #   # gum spin --spinner line --title "Evaluating $HOME_PKGS to $DIR/second.json" --
  #   nix eval "$HOME_PKGS" --json | tee "$DIR/second.json"

  #   cat "$DIR/first.json" "$DIR/second.json" | jq -s add | tee "$DIR/out.json" | gum pager
  # '';
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
        ack
        age
        agenix.packages.${system}.default
        alejandra
        attic.packages.${system}.default
        bash
        bfg-repo-cleaner
        colima
        comma
        deploy-machine
        deploy-rs.packages.${system}.default
        deployment
        direnv
        flake-checker.packages.${system}.default
        git
        gnupg
        gum
        mkiso
        netdiscover
        nil
        packages-json
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
