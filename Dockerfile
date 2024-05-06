FROM nixos/nix

RUN nix --extra-experimental-features "flakes nix-command" --accept-flake-config develop 'github:tomasharkema/nix-config/install-script-2' --impure

RUN nix --extra-experimental-features "flakes nix-command" --accept-flake-config build 'github:tomasharkema/nix-config/install-script-2#images.installer-x86'
