#!/bin/sh

set -u
set -f # disable globbing
export IFS=' '

echo "Uploading paths" $OUT_PATHS
exec nix copy --to "https://nix-cache.harke.ma/" $OUT_PATHS
