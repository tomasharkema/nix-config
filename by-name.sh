#!/usr/bin/env bash
set -x

SYSTEMS=$(find systems -name "default.nix")

mkdir systems-by-name

for system in $SYSTEMS; do
  dir="$(dirname "$system")"
  base="$(basename "$dir")"
  echo "$base $dir"

  ln -snf "../$dir" "systems-by-name/$base"

done
