{
  pkgs,
  lib,
  ...
}:
pkgs.writeShellApplication {
  name = "menu";

  runtimeInputs = with pkgs; [gum nixos-rebuild nix-output-monitor zsh fast-ssh];

  text = ''
    RUN_UPDATER="Run Updater..."
    OPEN_BLUE_FIRE="SSH blue-fire..."
    OPEN_SSH="SSH..."
    OPEN_SHELL="Go to shell!"
    EXIT="Exit"

    update () {
      sudo nixos-rebuild switch --flake "github:tomasharkema/nix-config/update" --refresh --verbose --log-format internal-json -v |& nom --json
    }

    CHOICE=$(gum choose "$RUN_UPDATER" "$OPEN_BLUE_FIRE" "$OPEN_SSH" "$OPEN_SHELL" "$EXIT")

    case $CHOICE in
      "$RUN_UPDATER")
        update
        ;;

      "$OPEN_BLUE_FIRE")
        exec ssh blue-fire-menu
        ;;

      "$OPEN_SSH")
        exec fast-ssh
        ;;

      "$OPEN_SHELL")
        exec zsh
        ;;

      "$EXIT")
        echo "Exitting..."
        exit 0
        ;;

      *)
        exit 1
        ;;
    esac
  '';
}
