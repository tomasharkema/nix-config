#! /usr/bin/env sh

cd $WORK_DIR

OUT="$WORK_DIR/$IMAGE"

RES="$(nix build ".#images.x86_64-linux.$IMAGE" --out-link "$OUT" --json --accept-flake-config)"
echo $RES | jq

FILENAME="$IMAGE.tar.zst"
OUTPUT_FILE=$HOME/$FILENAME

tar chvf - "$OUT" | pv -N in -B 100M | zstd -e - | pv -N out -B 100M >$OUTPUT_FILE

# cp $OUT @file.outputfile.sha@

echo "RUNDECK:DATA:OUTPUT_FILE = $OUTPUT_FILE"
