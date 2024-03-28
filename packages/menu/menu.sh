# shellcheck disable=SC2148

RUN_UPDATER="Run Updater..."
ATTACH_SESSION="Attach to session..."
OPEN_BLUE_FIRE="SSH blue-fire..."
OPEN_SSH="SSH..."
SEARCH_DOCS="Search docs..."
CLEAR_CACHE="Clear cache..."
OPEN_SHELL="Go to shell!"
CLEAN_RAM="Clean ram..."
EXIT="Exit"

update() {
  sudo nixos-rebuild switch --flake "github:tomasharkema/nix-config" --refresh --verbose --log-format internal-json -v 2>&1 | nom --json
}

clearcache() {
  sudo nix-collect-garbage --delete-older-than '7d'
  nix-collect-garbage --delete-older-than '7d'
  echo "-- nix store optimise --"
  nix store optimise
}

attachsession() {
  SESSION=$(tmux list-sessions -F \#S | gum filter --placeholder "Pick session...")
  tmux switch-client -t "$SESSION" || tmux attach -t "$SESSION"
}

cleanram() {
  sudo sync
  sudo echo 3 | sudo tee /proc/sys/vm/drop_caches
}

search_docs() {
  INPUT="$(gum input --placeholder "Search in docs...")"
  manix "$INPUT"
  nix-search "$INPUT"
}

CHOICE=$(gum choose "$RUN_UPDATER" "$ATTACH_SESSION" "$OPEN_BLUE_FIRE" "$OPEN_SSH" "$SEARCH_DOCS" "$CLEAR_CACHE" "$OPEN_SHELL" "$CLEAN_RAM" "$EXIT")

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
"$SEARCH_DOCS")
  search_docs
  ;;

"$CLEAR_CACHE")
  clearcache
  ;;

"$ATTACH_SESSION")
  attachsession
  ;;

"$CLEAN_RAM")
  cleanram
  ;;

"$EXIT")
  echo "Exitting..."
  exit 0
  ;;

*)
  exit 1
  ;;
esac
