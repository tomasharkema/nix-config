#! /usr/bin/env nix-shell
#! nix-shell -i bash -p jq -p bash -p git
#! nix develop

set -x
set -e

echo @file.output-image.sha@

TEMP=$(mktemp -d)

echo "RUNDECK:DATA:TEMP = $TEMP"

cd $TEMP

git clone git@github.com:tomasharkema/nix-config.git

cd $TEMP/nix-config

OUT="$TEMP/@option.image@"

RES="$(nix build ".#images.x86_64-linux.@option.image@" --out-link "$OUT" --json --accept-flake-config)"
echo $RES | jq

FILENAME="@option.image@.tar.zst"
OUTPUT_FILE=$HOME/$FILENAME

tar chvf - "$OUT" | pv -N in -B 100M | zstd -e - | pv -N out -B 100M >$OUTPUT_FILE

# cp $OUT @file.outputfile.sha@

rm -rf $TEMP

echo "RUNDECK:DATA:OUTPUT_FILE = $OUTPUT_FILE"
