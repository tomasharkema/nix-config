#!/bin/sh

# set -u
set -f # disable globbing
export IFS=' '

echo "Uploading paths $OUT_PATHS $DRV_PATH"

# nix store sign --key-file cache-priv-key.pem --verbose $OUT_PATHS $DRV_PATH

# exec nix copy --to "https://nix-cache.harke.ma/" $OUT_PATHS $DRV_PATH
