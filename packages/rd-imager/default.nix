{pkgs, ...}:
pkgs.writeShellApplication {
  name = "rd-imager";

  runtimeInputs = with pkgs; [zstd pv];

  text = ''
    set -e
    set -x

    WORK_DIR="$1"

    echo "Run imager: $2"

    IMAGE="$2"

    cd "$WORK_DIR"

    OUT="$WORK_DIR/$IMAGE"

    # RES="$(nix build ".#images.x86_64-linux.$IMAGE" --out-link "$OUT" --verbose)"
    nix build ".#images.x86_64-linux.$IMAGE" --out-link "$OUT"

    echo "RUNDECK:DATA:OUT_LINK = $OUT"

    FILENAME="$IMAGE.tar.zst"
    OUTPUT_FILE=$HOME/$FILENAME

    tar chvf - "$OUT" | pv -N in -B 100M | zstd -e - | pv -N out -B 100M > "$OUTPUT_FILE"

    # cp $OUT @file.outputfile.sha@

    echo "RUNDECK:DATA:OUTPUT_FILE = $OUTPUT_FILE"

    # URL="$(curl "https://transfer.sh/$FILENAME" --upload-file "$OUTPUT_FILE")"

    # echo "RUNDECK:DATA:OUTPUT_URL = $URL"
  '';
}
