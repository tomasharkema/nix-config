#!/bin/sh

NAMES="$(nix eval '.#nodes' --apply 'builtins.attrNames' --json | jq -r -c '.[]')"

for name in $NAMES; do

  echo "$name ojoo"
  nix eval ".#nixosConfigurations.${name}.config.age.rekey.storageMode" --json
done
