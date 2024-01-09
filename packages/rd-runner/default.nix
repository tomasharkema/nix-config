{
  pkgs,
  lib,
  ...
}:
pkgs.writeShellApplication {
  name = "rd-runner";
  runtimeInputs = with pkgs; [file custom.rd-imager bash];
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

    ${lib.getExe pkgs.custom.rd-imager} "$WORK_DIR/nix-config" "$2"

    rm -rf "$WORK_DIR"
  '';
}
