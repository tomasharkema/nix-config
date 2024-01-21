{
  pkgs,
  lib,
  ...
}:
pkgs.writeShellApplication {
  name = "menu";
  
  runtimeInputs = with pkgs; [gum nixos-rebuild nix-output-monitor zsh];

  text = ''
    RUN_UPDATER="Run Updater"
    OPEN_SHELL="Go to shell!"
    EXIT="Exit"

    update () {
      sudo nixos-rebuild switch --flake "github:tomasharkema/nix-config/update" --log-format internal-json -v |& nom --json
    }

    CHOICE=$(gum choose "$RUN_UPDATER" "$OPEN_SHELL" "$EXIT")
    
    case $CHOICE in
      "$RUN_UPDATER")
        update
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
