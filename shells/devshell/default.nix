{ inputs, pkgs, lib, config, ... }:
with pkgs;
with lib;
let
  write-script = writeShellScriptBin "write-script" ''
    set -x
    echo "pv $1 $2"
    pv $1 -cN in -B 500M -pterbT | zstd -d - | pv -cN out -B 500M -pterbT > $2
  '';
  deployment = writeShellScriptBin "deployment" ''
    ${pkgs.deploy-rs}/bin/deploy --skip-checks --targets $@ -- --log-format internal-json -v |& ${pkgs.nix-output-monitor}/bin/nom --json
  '';
  deploy-all = writeShellScriptBin "deploy-all" ''
    ${pkgs.deploy-rs}/bin/deploy --skip-checks -- --log-format internal-json -v |& ${pkgs.nix-output-monitor}/bin/nom --json
  '';
  deploy-machine = writeShellScriptBin "deploy-machine" ''
    set -x
    ${pkgs.deploy-rs}/bin/deploy --skip-checks ".#$@" -- --log-format internal-json -v |& ${pkgs.nix-output-monitor}/bin/nom --json
  '';
  reencrypt = writeShellScriptBin "reencrypt" ''
    cd secrets;
    agenix -r
  '';
  mkiso = writeShellScriptBin "mkiso" ''
    LINK="./out/install.iso";
    nom build '.#nixosConfigurations.hyperv-nixos.config.formats.install-iso' --out-link $LINK
    pv $LINK -cN in -B 100M -pterbT | xz -T4 -9 | pv -cN out -B 100M -pterbT > ./out/install.iso.xz
  '';
  remote-deploy = writeShellScriptBin "remote-deploy" ''
    remote deployment '.#arthur' '.#enzian'
  '';
  upload-all = writeShellScriptBin "upload-all" ''
    FILES="/nix/store/*"
    for f in $FILES
    do
      echo "Processing $f file..."
      attic push tomas "$f"
    done
  '';

  update-pkgs = writeShellScriptBin "update-pkgs" ''
    set -x
    nixPath="$(nix eval -f . inputs.nixpkgs.outPath --json | jq -r)"
    echo "found $nixPath"
    nixUpdate="$nixPath/maintainers/scripts/update.nix"
    echo "found $nixUpdate"
    overlayExpr="(import {./.} {{ }}).outputs.overlays"
    nix-shell $nixUpdate --arg include-overlays $overlayExpr --arg predicate '(path: pkg: true)' --verbose --show-trace $@
  '';

  test-installer = writeShellScriptBin "test-installer" ''
    VM_PATH="$(nix build '.#nixosConfigurations.installer-x86.config.system.build.vm' --print-out-paths)"
    QEMU_KERNEL_PARAMS=console=ttyS0 $VM_PATH/bin/run-nixos-vm -nographic; reset
  '';

  # cachix-deploy = writeShellScriptBin "cachix-deploy" ''
  #   set -x
  #   set -e
  #   spec=$(nom build --print-out-paths)
  #   echo $spec
  #   cat $spec
  #   cachix push tomasharkema $spec
  # '';

  # example: `cachix-reploy-pin "darwinConfigurations.euro-mir.config.system.build.toplevel" "darwin-0.1"`
  # cachix-reploy-pin = writeShellScriptBin "cachix-reploy-pin" ''
  #   set -x
  #   set -e

  #   res="$(nom build ".#$1" --json | jq '.[0].outputs.out' -r)"

  #   cachix push tomasharkema $res
  #   cachix pin tomasharkema $2 $res
  # '';

  dconf-update = writeShellScriptBin "dconf-update" ''
    ${lib.getExe pkgs.dconf} dump / > dconf.settings
    ${lib.getExe pkgs.dconf2nix} -i dconf.settings -o dconf.nix
  '';
  dconf-save = writeShellScriptBin "dconf-save" ''
    current_hostname="$(hostname)"
    echo "Saving dconf for $current_hostname"
    ${lib.getExe pkgs.dconf} dump / > "dconf/$current_hostname.conf"
  '';

  test-remote = writeShellScriptBin "test-remote" ''
    SERVER="$1"
    echo "test remote $SERVER..."
    exec ${
      lib.getExe pkgs.buildPackages.nixos-rebuild
    } test --flake ".#$SERVER" --target-host "$SERVER" --use-remote-sudo --verbose --show-trace -L
  '';

  upload-local = writeShellScriptBin "upload-local" ''
    nix copy -v --substitute-on-destination --to 'ssh://blue-fire?compression=zstd&secret-key=/run/agenix/peerix-private' /run/current-system
  '';

  upload-to-installer = writeShellScriptBin "upload-to-installer" ''
    configuration="$1"
    host="$2"
    flake="nixosConfigurations.\"$configuration\".config.system.build.toplevel"

    echo "Copy $flake to $host"

    nix copy --to "ssh-ng://$host?remote-store=local?root=/mnt" ".#$flake" --derivation --no-check-sigs

    nix build ".#$flake" --eval-store auto --store "ssh-ng://$host?remote-store=local?root=/mnt"
  '';

  dp = writeShellScriptBin "dp" ''
    configuration="$1"
    host="$2"
    flake="nixosConfigurations.\"$configuration\".config.system.build.toplevel"

    echo "Copy $flake to $host"

    exec nixos-rebuild test --flake ".#$configuration" --verbose --target-host $host --use-remote-sudo
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
  upload-all-store = writeShellScriptBin "upload-all-store" ''
    NPATHS=50
    NPROCS=4

    exec nix path-info --all | xargs -n$NPATHS -P$NPROCS attic push tomas -j 1
  '';
in inputs.devenv.lib.mkShell {
  inherit inputs pkgs;

  modules = [{
    # starship.enable = true;

    # languages.nix = {
    #   enable = true;
    #   lsp.package = nixd;
    # };
    pre-commit.hooks = {
      nixfmt.enable = true;
      shellcheck.enable = true;
      # nixd.enable = true;
      # nil.enable = true;
      # statix.enable = true;
    };

    devcontainer = {
      enable = true;
      settings.customizations.vscode.extensions = [
        "Catppuccin.catppuccin-vsc-pack"
        "jnoortheen.nix-ide"
        "mkhl.direnv"
        "brettm12345.nixfmt-vscode"
      ];
    };
    difftastic.enable = true;

    # dotenv.enable = true;

    packages = [
      nixos-generate

      nixVersions.nix_2_22 # Unstable
      upload-all-store
      # cntr
      update-pkgs
      attic-client
      dconf-save
      dp
      upload-to-installer
      # pkgs.custom.rundesk
      ack
      age
      agenix
      bash
      bfg-repo-cleaner
      # cachix-deploy
      # cachix-reploy-pin
      colima
      comma
      dconf-update
      dconf2nix
      deploy-all
      deploy-machine
      pkgs.deploy-rs
      deployment
      direnv
      # flake-checker
      git
      gnupg
      gum
      tydra
      hydra-check
      hydra-cli
      mkiso
      netdiscover
      nil
      nixd
      nix-output-monitor
      nix-prefetch-scripts
      pkgs.custom.remote-cli
      reencrypt
      remote-deploy
      sops
      ssh-to-age
      statix
      test-remote
      upload-all
      upload-local
      write-script
      zsh
      agenix # .packages.${system}.default
      nixfmt-rfc-style

      # cachix
      deadnix
      hydra-cli
      test-installer
      nil
      manix
      nix-eval-jobs
      # nix-init
      nix-output-monitor
      nix-prefetch-scripts
      # nix-serve
      nix-tree
      # nixci
      # nixos-shell
      nixpkgs-fmt
      nixpkgs-lint
      nurl
      # # snowfallorg.flake
      statix
    ];
  }];
}
