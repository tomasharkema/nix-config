{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
with lib;
with pkgs; let
  nixos-generate = inputs.nixos-generators.packages."${pkgs.system}".nixos-generate;

  _mbufferSend = writeShellScriptBin "_mbufferSend" ''
    mbuffer -I pegasus:8000 -m 1G | zstd -e - -19 | > pegasus-bak-2.tar.zst
    ssh media@pegasus.local "tar chf - /home/media | mbuffer -m 100M -O euro-mir-2:8000"

  '';

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
    exec ${lib.getExe pkgs.buildPackages.nixos-rebuild} test --flake ".#$SERVER" --target-host "$SERVER" --use-remote-sudo --verbose --show-trace -L --use-substitutes
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

    exec nixos-rebuild test --flake ".#$configuration" --verbose --target-host $host --use-remote-sudo --use-substitutes
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

  build-host-pkgs = writeShellScriptBin "build-host-pkgs" ''
    PACKAGE="$1"
    echo "Build $PACKAGE"
    exec nom build ".#nixosConfigurations.$HOSTNAME.pkgs.$PACKAGE" --out-link ./out/$PACKAGE --verbose --show-trace -L
  '';
  nixos-system = writeShellScriptBin "nixos-system" ''
    HOST="$1"
    echo "Build $HOST"
    exec nom build ".#nixosConfigurations.$HOST.config.system.build.toplevel" --out-link ./out/$HOST --verbose --show-trace -L
  '';
  darwin-system = writeShellScriptBin "darwin-system" ''
    HOST="$1"
    echo "Build $HOST"
    exec nom build ".#darwinConfigurations.$HOST.config.system.build.toplevel" --out-link ./out/$HOST --verbose --show-trace -L
  '';
in {
  # starship.enable = true;

  languages.nix = {
    # enable = true;
    lsp.package = nil;
  };

  pre-commit.hooks = {
    alejandra.enable = true;
    shellcheck.enable = true;
    # nixd.enable = true;
    # statix.enable = true;
  };

  devcontainer = {
    enable = true;
    settings.customizations.vscode.extensions = [
      "Catppuccin.catppuccin-vsc-pack"
      "jnoortheen.nix-ide"
      "mkhl.direnv"
      "kamadorueda.alejandra"
    ];
  };
  difftastic.enable = true;

  # dotenv.enable = true;

  packages = with pkgs; [
    #pkgs.nixVersions.latest
    nixos-system
    darwin-system
    build-host-pkgs
    # # snowfallorg.flake
    # agenix
    # cachix
    # cachix-deploy
    # cachix-reploy-pin
    # cntr
    flake-checker
    hydra-cli
    autoflake
    # nix-init
    # nix-serve
    # nixci
    # nixos-shell
    # pkgs.custom.remote-cli
    # pkgs.custom.rundesk
    ack
    age
    alejandra
    attic-client
    bash
    bfg-repo-cleaner
    colima
    dconf-save
    dconf-update
    dconf2nix
    deadnix
    deploy-all
    deploy-machine
    deployment
    direnv
    dp
    git
    gnupg
    gum
    hydra-check
    hydra-cli
    hydra-cli
    manix
    mkiso
    netdiscover
    nil
    nix-eval-jobs
    nix-output-monitor
    nix-output-monitor
    nix-prefetch-scripts
    nix-prefetch-scripts
    nix-tree
    # nixd
    nixfmt-rfc-style
    nixos-generate
    nixpkgs-fmt
    nixpkgs-lint
    nurl
    deploy-rs
    reencrypt
    remote-deploy
    sops
    ssh-to-age
    statix
    statix
    test-installer
    test-remote
    tydra
    update-pkgs
    upload-all
    upload-all-store
    upload-local
    upload-to-installer
    write-script
    zsh
  ];
}
