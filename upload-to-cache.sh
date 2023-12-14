#!/bin/sh

set -u
set -f # disable globbing
export IFS=' '

# set -x

execute() {

	set -x

	echo "====="
	whoami

	echo "Uploading paths $OUT_PATHS"
	echo "DERV  $DRV_PATH"

	nix store sign --key-file cache-priv-key.pem --verbose $OUT_PATHS $DRV_PATH

	nix copy --to "https://nix-cache.harke.ma/" --verbose $OUT_PATHS $DRV_PATH

	echo "done"
}

execute | tee -a /tmp/nix.log
