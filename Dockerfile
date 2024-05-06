FROM nixos/nix

RUN nix --extra-experimental-features "flakes nix-command" --accept-flake-config build 'github:tomasharkema/nix-config#images.installer-x86'