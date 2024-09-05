{
  inputs,
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
with lib; {
  config = let
    key_path = "${config.home.homeDirectory}/.atuin/key";
  in {
    home.activation.atuin-key = inputs.home-manager.lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ -f "${osConfig.age.secrets.atuin.path}" ]; then
        install -Dm 600 "${osConfig.age.secrets.atuin.path}" "${key_path}"
      fi
    '';

    programs.atuin = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        key_path = key_path;
        # key_path = osConfig.age.secrets.atuin.path;
        sync_address = "https://atuin.harke.ma";
        auto_sync = true;
        sync_frequency = "10m";
        workspaces = true;
        style = "compact";
        secrets_filter = true;
        common_subcommands = ["cargo" "go" "git" "npm" "yarn" "pnpm" "kubectl" "nix" "nom" "nh"];
        daemon = mkIf pkgs.stdenv.isLinux {
          enabled = true;
          systemd_socket = true;
          socket_path = "/run/user/1000/atuin.sock";
        };
      };
    };

    # launchd.agents."atuin" = {
    #   enable = true;
    #   config = {
    #     ProgramArguments = [
    #       "${(pkgs.writeShellScript "atuin-daemon" ''
    #         exec ${getExe config.programs.atuin.package} daemon
    #       '')}"
    #     ];
    #     KeepAlive = true;
    #   };
    # };

    systemd.user = {
      services."atuin" = {
        Unit = {
          Description = "atuin";
          Requires = ["atuin.socket"];
        };

        Install.WantedBy = ["default.target"];

        Service = {
          ExecStart = "${getExe config.programs.atuin.package} daemon";
          Restart = "on-failure";
          RestartSec = "5s";
        };
      };

      sockets."atuin" = {
        Unit = {Description = "atuin";};
        Socket = {
          ListenStream = "%t/atuin.sock";
        };
        Install.WantedBy = ["sockets.target"];
      };
    };
  };
}
