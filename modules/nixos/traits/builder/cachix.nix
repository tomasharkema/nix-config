{
  pkgs,
  config,
}: let
  upload_to_cachix = pkgs.writeScriptBin "upload-to-cachix" ''
    #!/bin/sh
    set -eu
    set -f # disable globbing

    # skip push if the declarative job spec
    OUT_END=$(echo ''${OUT_PATHS: -10})
    if [ "$OUT_END" == "-spec.json" ]; then
    exit 0
    fi

    export HOME=/root
    exec ${pkgs.cachix}/bin/cachix -c /etc/cachix/cachix.dhall push tomasharkema $OUT_PATHS > /tmp/hydra_cachix 2>&1
  '';
in {
  # nix.extraOptions = ''
  #   builders-use-substitutes = true
  #   post-build-hook = ${upload_to_cachix}/bin/upload-to-cachix
  # '';
}
