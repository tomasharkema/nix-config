{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (pkgs) stdenv;
  # tmux-menu = pkgs.writeShellScriptBin "tmux-menu" ''
  #   # Get a list of existing tmux sessions:
  #   TMUX_SESSIONS=$(tmux ls | awk -F: '{print $1}')
  #   # If there are no existing sessions:
  #   if [[ -z $TMUX_SESSIONS ]]; then
  #       echo "No existing tmux sessions. Creating a new session called 'default'..."
  #       tmux new -s default
  #   else
  #       # Present a menu to the user:
  #       echo "Existing tmux sessions:"
  #       echo "$TMUX_SESSIONS"
  #       echo "Enter the name of the session you want to attach to, or 'new' to create a new session: "
  #       read user_input
  #       # Attach to the chosen session, or create a new one:
  #       if [[ $user_input == "new" ]]; then
  #           echo "Enter name for new session: "
  #           read new_session_name
  #           tmux new -s $new_session_name
  #       else
  #           tmux attach -t $user_input
  #       fi
  #   fi
  # '';
in {
  # nix.settings = {
  #   extra-experimental-features = "nix-command flakes";
  #   # distributedBuilds = true;
  #   trusted-users = [ "root" "tomas" ];
  #   extra-substituters = [
  #     # "ssh://nix-ssh@silver-star.ling-lizard.ts.net"
  #     "https://nix-cache.harke.ma/"
  #     "https://tomasharkema.cachix.org/"
  #     "https://cache.nixos.org/"
  #   ];
  #   extra-binary-caches = [
  #     "https://nix-cache.harke.ma/"
  #     "https://tomasharkema.cachix.org/"
  #     "https://cache.nixos.org/"
  #   ];
  #   extra-trusted-public-keys = [
  #     "silver-star.ling-lizard.ts.net:MBxJ2O32x6IcWJadxdP42YGVw2eW2tAbMp85Ws6QCno="
  #     "tomasharkema.cachix.org-1:LOeGvH7jlA3vZmW9+gHyw0BDd1C8a0xrQSl9WHHTRuA="
  #   ];
  #   access-tokens = [ "github.com=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" ];
  # };

  # imports = [
  #   ./apps/tmux
  #   inputs.nix-index-database.hmModules.nix-index
  #   ./apps/keybase
  #   ./apps/gnome/dconf.nix
  #   ./apps/nvim
  # ];
}
