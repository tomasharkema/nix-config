{
  pkgs,
  lib,
  ...
}:
pkgs.writeShellApplication {
  name = "menu";

  runtimeInputs = with pkgs; [gum nixos-rebuild nix-output-monitor zsh fast-ssh dialog];

  text = ''
    # NIX_ARGS="--accept-flake-config --refresh --verbose"

    RUN_UPDATER="Run Updater..."
    ATTACH_SESSION="Attach to session..."
    OPEN_BLUE_FIRE="SSH blue-fire..."
    OPEN_SSH="SSH..."
    CLEAR_CACHE="Clear cache..."
    OPEN_SHELL="Go to shell!"
    EXIT="Exit"

    update () {
      exec sudo nixos-rebuild switch --flake "github:tomasharkema/nix-config/update" --refresh --verbose --log-format internal-json -v |& nom --json
    }

    clear-cache () {
      OUTPUT="$(mktemp)"
      {
        nix-collect-garbage --delete-older-than '1d' 2>&1;
        echo "-- nix store optimise --";
        nix store optimise 2>&1;
      } > "$OUTPUT" &
      dialog --title "Run garbage collector..." --tailbox "$OUTPUT" 30 125 --clear
    }

    attach-session () {
      SESSION=$(tmux list-sessions -F \#S | gum filter --placeholder "Pick session...")
      tmux switch-client -t "$SESSION" || tmux attach -t "$SESSION"
    }

    CHOICE=$(gum choose "$RUN_UPDATER" "$ATTACH_SESSION" "$OPEN_BLUE_FIRE" "$OPEN_SSH" "$CLEAR_CACHE" "$OPEN_SHELL" "$EXIT")

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

      "$CLEAR_CACHE")
        clear-cache
        ;;

      "$ATTACH_SESSION")
        attach-session
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
