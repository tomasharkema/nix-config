{
  inputs,
  pkgs,
  lib,
  ...
} @ attrs:
with pkgs;
with lib; let
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
  cachix-deploy = writeShellScriptBin "cachix-deploy" ''
    set -x
    set -e
    spec=$(nom build --print-out-paths)
    echo $spec
    cat $spec
    cachix push tomasharkema $spec
  '';

  # example: `cachix-reploy-pin "darwinConfigurations.euro-mir.config.system.build.toplevel" "darwin-0.1"`
  cachix-reploy-pin = writeShellScriptBin "cachix-reploy-pin" ''
    set -x
    set -e

    res="$(nom build ".#$1" --json | jq '.[0].outputs.out' -r)"

    cachix push tomasharkema $res
    cachix pin tomasharkema $2 $res
  '';
  # diffs = import ../diffs attrs;
  # packages-json = diffs.packages-json;
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
  nix-install-pkgs = import ../../modules/home/tools/nix/nixpkgs.nix {inherit pkgs inputs;};
in
  inputs.devenv.lib.mkShell {
    # name = "devshell";
    # allowUnfree = true;

    # defaultPackage = zsh;
    # buildInputs = [pkgs.home-manager];

    inherit inputs pkgs;
    # nix-profiler
    modules = [
      ({
        pkgs,
        config,
        ...
      }: {
        # https://devenv.sh/basics/
        env.GREET = "devenv";

        enterShell = ''
          git status
        '';

        # https://devenv.sh/languages/
        languages.nix.enable = true;

        # https://devenv.sh/scripts/
        # scripts.hello.exec = "echo hello from $GREET";

        # https://devenv.sh/pre-commit-hooks/
        pre-commit.hooks.shellcheck.enable = true;

        # https://devenv.sh/processes/
        processes.ping.exec = "ping harkema.io";

        # dotenv.enable = true;

        difftastic.enable = true;

        packages = with inputs;
          [
            flake-checker.packages.${system}.default
            deploy-rs.packages.${system}.default
            attic.packages.${system}.default
            agenix.packages.${system}.default
            hydra-check.packages.${system}.default
            nil.packages.${system}.default
          ]
          ++ [
            snowfallorg.flake
          ]
          ++ [
            pkgs.custom.rundesk
            reencrypt
            pkgs.custom.remote-cli
          ]
          ++ [
            ack
            age
            alejandra
            bash
            bfg-repo-cleaner
            colima
            comma
            deploy-machine
            deployment
            direnv
            git
            gnupg
            gum
            mkiso
            netdiscover

            # packages-json
            python3

            remote-deploy

            sops
            ssh-to-age
            write-script
            zsh
            cachix-deploy
            cachix-reploy-pin
          ]
          ++ nix-install-pkgs;

        # shellHook = ''
        #   git status
        # '';
      })
    ];
  }
