#!/bin/sh

# set -x

# MATCH="([^\/]*\/[^\/]*)\.git"

FLAKE_ACC="(builtins.getFlake \"$(pwd)\")"

PACKAGES="$(nix eval --expr "builtins.attrNames $FLAKE_ACC.packages.\"\${builtins.currentSystem}\"" --json --impure | jq '.[]' -r)"

for pkg in $PACKAGES; do
  (
    set -e
    echo "checking: $pkg..."

    PKG_INFO="$(nix eval --expr "let pkg = $FLAKE_ACC.packages.\"\${builtins.currentSystem}\".$pkg; in {rev=pkg.src.rev;repo=pkg.src.gitRepoUrl;}" --json --impure | jq -r)"

    echo "Package version: $PKG_INFO"

    GH_RELEASES="$(gh list releases)"
    echo "$GH_RELEASES"
  )
done
