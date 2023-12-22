{ pkgs, ... }:
let
  inherit (pkgs) stdenv;
  inherit (pkgs) lib;

  unstable = import (fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz) { };
  toolchains = [ unstable.jdk11 unstable.jdk17 ];

in
rec {
  rd-deps = stdenv.mkDerivation {
    name = "rd-deps";

    src = pkgs.fetchFromGitHub {
      owner = "rundeck";
      repo = "rundeck-cli";
      rev = "d0037a653f9c57f1e62df7c0369205943ae147c9";
      sha256 = "sha256:IK/WHO5s5EiJMV2nMlVqHqk5L1jXk8dklkJm15DVZ1U=";
    };
    __noChroot = true;

    nativeBuildInputs = [
      pkgs.gradle_7
    ];

    buildPhase = ''
      export GRADLE_USER_HOME="/tmp/.gradledeps"

      gradle --no-daemon --no-build-cache --info --full-stacktrace --warning-mode=all \
        :rd-cli-tool:dependencies dependencies
    '';

    installPhase = ''
      mkdir -p $out
      mv /tmp/.gradledeps $out
      mv .gradle $out
    '';
  };

  rd = stdenv.mkDerivation {

    name = "rd";
    meta = with lib; {
      mainProgram = "rd";
      sourceProvenance = with sourceTypes; [
        binaryBytecode
        binaryNativeCode
      ];
    };

    src = pkgs.fetchFromGitHub {
      owner = "rundeck";
      repo = "rundeck-cli";
      rev = "d0037a653f9c57f1e62df7c0369205943ae147c9";
      sha256 = "sha256:IK/WHO5s5EiJMV2nMlVqHqk5L1jXk8dklkJm15DVZ1U=";
    };

    nativeBuildInputs = [
      pkgs.gradle_7
      # rd-deps
    ];

    # buildInputs = [ pkgs.rsync ];
    __noChroot = true;

    # rsync -a ${rd-deps}/.gradledeps/ $TMPHOME/
    # rsync -a ${rd-deps}/.gradle/ $TMPHOME/
    # chmod 777 -R $TMPHOME
    # --offline

    buildPhase = ''
    
      TMPHOME="$(mktemp -d)"
      mkdir -p "$TMPHOME/init.d"
      export GRADLE_USER_HOME="$TMPHOME"

      gradle :rd-cli-tool:installDist --no-daemon \
        --no-build-cache --info --full-stacktrace --warning-mode=all
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

      ${lib.getExe imager} "$WORK_DIR/nix-config" "$2"

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
