{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
with lib; {
  config = {
    programs.atuin = {
      enable = true;
      enableZshIntegration = true;
      package = pkgs.unstable.atuin;
      settings = {
        key_path = osConfig.age.secrets.atuin.path;
        sync_address = "https://atuin.harke.ma";
        auto_sync = true;
        sync_frequency = "10m";
        workspaces = true;
        style = "compact";
        secrets_filter = true;
        common_subcommands = ["cargo" "go" "git" "npm" "yarn" "pnpm" "kubectl" "nix" "nom" "nh"];
        daemon = {
          enabled = true;
          # systemd_socket = pkgs.stdenv.isLinux;
          # socket_path = "/run/user/1000/atuin.sock";
        };
      };
    };

    launchd.agents."atuin" = {
      enable = true;
      config = {
        ProgramArguments = [
          "${(pkgs.writeShellScript "atuin-daemon" ''
            exec ${getExe config.programs.atuin.package} daemon
          '')}"
        ];
        KeepAlive = true;
      };
    };

    systemd.user = {
      services."atuin" = {
        Unit = {Description = "atuin";};

        Install.WantedBy = ["multi-user.target"];

        Service = {
          ExecStart = "exec ${getExe config.programs.atuin.package} daemon";
          Restart = "on-failure";
          RestartSec = "5s";
        };
      };
      # sockets."atuin" = {
      #   Unit = {Description = "atuin";};
      #   Socket = {
      #     ListenStream = "%t/atuin.sock";
      #     RuntimeDirectory = "atuin";
      #   };
      #   Install.WantedBy = ["sockets.target"];
      # };
    };
  };
}
