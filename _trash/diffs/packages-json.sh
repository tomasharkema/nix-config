#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash nix-eval-jobs gum

set -euxo pipefail

ROOT=$(pwd)

export DIR="$(mktemp -d)"

# nix flake archive --to file://$DIR/cache ".#"

# gum log --structured --level info "Using folder $DIR"

# nix eval --with . --expr 'with inputs.nixpkgs.lib; (mapAttrsToList (name: value: "nixosConfigurations." + name) nixosConfigurations) ++ (mapAttrsToList (name: value: "darwinConfigurations." + name) darwinConfigurations' --json | jq

GET_HOSTS="
{system ? builtins.currentSystem}:
toString $ROOT/.
"
# {system ? builtins.currentSystem}: let
#   flake = builtins.getFlake (toString ./.);
# in
# flake.inputs
#   with flake.inputs.nixpkgs.lib;
#     mapAttrsToList (name: value: \"nixosConfigurations.\" + name) flake.outputs.nixosConfigurations ++
#          mapAttrsToList (name: value: \"darwinConfigurations.\" + name) flake.outputs.darwinConfigurations
# "

DERP="$(nix-eval-jobs --gc-roots-dir gc-root --expr "$GET_HOSTS" | jq)"
echo $DERP

exit 1

# HOSTS="$(nix eval ".#deploy.nodes" --json --apply builtins.attrNames | jq -r 'join("\n")')"
# DARWIN_SYSTEMS=$(nix eval ".#darwinConfigurations" --json --apply builtins.attrNames | jq -r 'join(" ")')
# NIXOS_SYSTEMS=$(nix eval ".#nixosConfigurations" --json --apply builtins.attrNames | jq -r 'join(" ")')

# FILTER="$(echo -e "$DARWIN_SYSTEMS $NIXOS_SYSTEMS" | gum filter --title "Which host do you want to use?")"
FILTER="$(echo "$HOSTS" | gum filter)"

PREFIX="$(nix eval ".#nixosConfigurations.$FILTER.config.environment.systemPackages" --json >/dev/null && echo "nixosConfigurations" || echo "darwinConfigurations")"

FLAKE_NAME="$PREFIX.$FILTER"

SYSTEM_PKGS=".#$FLAKE_NAME.config.environment.systemPackages"

# gum log --structured --level info "Evaluating $SYSTEM_PKGS" flake $SYSTEM_PKGS dir $DIR/first.json
# gum spin --spinner line --title "Evaluating $SYSTEM_PKGS to $DIR/first.json" --
nix eval "$SYSTEM_PKGS" --json | tee "$DIR/first.json"

HOME_PKGS=".#$FLAKE_NAME.config.home-manager.users.tomas.home.packages"
# gum log --structured --level info "Evaluating $HOME_PKGS" flake $SYSTEM_PKGS dir $DIR/second.json
# gum spin --spinner line --title "Evaluating $HOME_PKGS to $DIR/second.json" --
nix eval "$HOME_PKGS" --json | tee "$DIR/second.json"

cat "$DIR/first.json" "$DIR/second.json" | jq -s add | tee "$DIR/out.json" | gum pager
