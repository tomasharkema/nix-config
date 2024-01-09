#! /usr/bin/env nix-shell
#! nix-shell -i bash -p jq -p bash --pure

set -x;
set -e;

cd /home/agent/nix-config
git pull

TEMP=$(mktemp -d)
OUT="$TEMP/@option.image@"

RES="$(nix build ".#images.x86_64-linux.@option.image@" --out-link "$OUT" --json)"
echo $RES | jq

tar cJhf - "$OUT" | xz -9 -T4 >  "./out/@option.image@.tar.xz"
