{ pkgs, ... }:
let
  inherit (pkgs) stdenv;
in
rec {

  rd = stdenv.mkDerivation {

    name = "rundeck";

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
      gradle :rd-cli-tool:installDist
    '';

    installPhase = ''
      mv rd-cli-tool/build/install/rd $out
    '';
  };

  run-imager = pkgs.writeShellScriptBin "run-imager" ''
    export RD_AUTH_PROMPT=false
    export RD_TOKEN="9LczxcesPidTMTpPAK1LSoWdVYi9wixx"
    export RD_URL=https://rundeck.harkema.io
    ${rd}/bin/rd run -i 513a69b3-116b-4d7e-b396-11adcc0117e5 -f -- -image $1
  '';

  imager = pkgs.writeShellScriptBin "imager" ''
    set -e
    set -x

    cd $WORK_DIR

    OUT = "$WORK_DIR/$IMAGE"

    RES="$(nix build ".#images.x86_64-linux.$IMAGE" --out-link "$OUT" --json --accept-flake-config)"
    echo $RES | jq

    FILENAME="$IMAGE.tar.zst"
    OUTPUT_FILE=$HOME/$FILENAME

    tar chvf - "$OUT" | pv -N in -B 100M | zstd -e - | pv -N out -B 100M > $OUTPUT_FILE

    # cp $OUT @file.outputfile.sha@

    echo "RUNDECK:DATA:OUTPUT_FILE = $OUTPUT_FILE"
  '';

  packages = with pkgs;[
    rd
    run-imager
  ];

  shell = pkgs.mkShell {
    name = "rundesk";

    buildInputs = with pkgs; [
      jq
      zstd
      pv

      imager
    ];
    # nativeBuildInputs = [ ];
    shellHook = ''
      echo "hello runner! $@";
    '';
  };
}
