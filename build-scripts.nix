_: {
  programs.zsh = {
    shellAliases = {
      # home-update =
      #   "nix build '.#darwinConfigurations.MacBook-Pro-van-Tomas.system' --json --refresh | jq -r '.[].outputs | to_entries[].value' | cachix push tomasharkema";
      # build-enceladus = ''
      #   nix build '.#nixosConfigurations."enceladus".config.system.build.toplevel' --json --refresh | jq -r '.[].outputs | to_entries[].value' | cachix push tomasharkema'';
      enceladus = "ssh tomas@enceladus";

      # deploy = "nix develop -c deploy .#.";

      # encrypt_keys = ''
      #   TEMP_DIR=$(mktemp -d); op read "op://Private/tomas-new/private_key?ssh-format=OpenSSH" --out-file $TEMP_DIR/id_ed25519; \
      #    cd secrets; \
      #    agenix -r -i $TEMP_DIR/id_ed25519; \
      #    rm -rf $TEMP_DIR
      # '';

      # reencrypt = ''
      #   cd secrets; \
      #     agenix -r
      # '';

    };
  };
}
