{
  inputs,
  lib,
  pkgs,
  config,
  osConfig,
  ...
}: {
  config = let
    checkFile = "${config.home.homeDirectory}/.atuin_key_copied_4242";
    key_path = "${config.home.homeDirectory}/.local/share/atuin/key";
  in {
    home.activation.atuin-key = inputs.home-manager.lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ ! -e "${checkFile}" ]; then

        if [ -e "${osConfig.age.secrets.atuin.path}" ]; then
          rm -rf "${config.home.homeDirectory}/.atuin/key"
          rm -rf "${key_path}"
          install -Dm 600 "${osConfig.age.secrets.atuin.path}" "${key_path}"
        fi

        touch "${checkFile}"
      fi
    '';

    programs.atuin = {
      enable = true;
      enableZshIntegration = true;

      daemon = {
        enable = true;
      };

      settings = {
        key_path = key_path;

        sync_address = "https://atuin.ling-lizard.ts.net";

        auto_sync = true;
        sync_frequency = "10m";
        workspaces = true;
        style = "compact";
        secrets_filter = true;
        filter_mode = "workspace";
        common_subcommands = ["cargo" "go" "git" "npm" "yarn" "pnpm" "kubectl" "nix" "nom" "nh"];
        # daemon = {
        #   enabled = true;
        #   systemd_socket = true;
        #   socket_path = "/run/user/1000/atuin.sock";
        # };
      };
    };
  };
}
