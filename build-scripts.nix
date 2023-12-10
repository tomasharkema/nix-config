{ ... }: {
  programs.zsh = {
    shellAliases = {
      home-update =
        "nix build '.#darwinConfigurations.MacBook-Pro-van-Tomas.system' --json --refresh | jq -r '.[].outputs | to_entries[].value' | cachix push tomasharkema";
      build-enceladus = ''
        nix build '.#nixosConfigurations."enceladus".config.system.build.toplevel' --json --refresh | jq -r '.[].outputs | to_entries[].value' | cachix push tomasharkema'';
    };
  };
}
