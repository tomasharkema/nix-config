{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.meshagent;
in {
  options.services.meshagent = {
    enable = (lib.mkEnableOption "mesh-agent") // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    age.secrets.meshagent = {
      rekeyFile = ./msh.age;
    };

    systemd.services = {
      meshagent = {
        enable = true;
        description = "meshagent background service";
        wants = ["network-online.target"];
        after = ["network-online.target"];

        serviceConfig = {
          WorkingDirectory = "/usr/local/mesh_services/meshagent/";
          ExecStart = "${pkgs.custom.mesh-agent}/bin/mesh-agent --installedByUser=0";
          # StandardOutput = "null";
          Restart = "on-failure";
          RestartSec = "5";
        };

        wantedBy = ["multi-user.target"];
        # alias = "meshagent.service";
      };
    };
  };
}
