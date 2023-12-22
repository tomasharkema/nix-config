{ pkgs, ... }:
let
  inherit (pkgs) stdenv;
in
rec {

  rd = stdenv.mkDerivation {

    name = "rd";
    meta.mainProgram = "rd";

    src = pkgs.fetchFromGitHub {
      owner = "rundeck";
      repo = "rundeck-cli";
      rev = "d0037a653f9c57f1e62df7c0369205943ae147c9";
      hash = "sha256-IK/WHO5s5EiJMV2nMlVqHqk5L1jXk8dklkJm15DVZ1U=";
    };
    nativeBuildInputs = [ ];

    buildInputs = [ pkgs.gradle_7 pkgs.openjdk19 ];

    buildPhase = ''
      rm -rf /tmp/gradle &> /dev/null
      mkdir /tmp/gradle 
      export GRADLE_USER_HOME="/tmp/gradle" 
      ./gradlew :rd-cli-tool:installDist
    '';

    installPhase = ''
      mv rd-cli-tool/build/install/rd $out
    '';
  };

  run-imager = pkgs.writeShellApplication {
    name = "imager";
    runtimeInputs = with pkgs; [ rd gum ];

    text = ''
      export RD_AUTH_PROMPT=false
      export RD_TOKEN="9LczxcesPidTMTpPAK1LSoWdVYi9wixx"
      export RD_URL=https://rundeck.harkema.io

      gum confirm "Build $1?"
      rd run -i 513a69b3-116b-4d7e-b396-11adcc0117e5 -f -- -image "$1" 
    '';
  };

  # pkgs.writeShellScriptBin "run-imager" ''
  #   export RD_AUTH_PROMPT=false
  #   export RD_TOKEN="9LczxcesPidTMTpPAK1LSoWdVYi9wixx"
  #   export RD_URL=https://rundeck.harkema.io

  #   echo "Run imager: $1"
  #   ${pkgs.lib.getExe rd} run -i 513a69b3-116b-4d7e-b396-11adcc0117e5 -f -- -image $1
  # '';

  imager = pkgs.writeShellApplication {
    name = "imager";

    runtimeInputs = with pkgs; [ zstd pv ];

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
  };

  packages = with pkgs;[
    rd
    run-imager
  ];

  runner = pkgs.writeShellApplication {
    name = "runner";
    runtimeInputs = with pkgs; [ file imager bash ];
    # interpreter = "${pkgs.bash}/bin/bash";

    text = ''
      set -x
      set -e

      WORK_DIR="$(mktemp -d)"
      cd "$WORK_DIR"

      echo "RUNDECK:DATA:TEMP = $WORK_DIR"

      git clone git@github.com:tomasharkema/nix-config.git

      cd "$WORK_DIR/nix-config"

      echo "hello runner! $1 $2";

      ${pkgs.lib.getExe imager} "$WORK_DIR/nix-config" "$2"

      rm -rf "$WORK_DIR"
    '';
  };

  shell = pkgs.mkShell {
    name = "rundesk";
    buildInputs = with pkgs; [
      runner
      imager
    ];

    defaultInput = runner;
  };
}
