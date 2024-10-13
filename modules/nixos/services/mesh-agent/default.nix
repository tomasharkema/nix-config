{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.meshagent;
  folder = "/usr/local/mesh_services/meshagent/";
in {
  options.services.meshagent = {
    enable = (lib.mkEnableOption "mesh-agent") // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    age.secrets.meshagent = {
      rekeyFile = ./msh.age;
    };

    systemd = {
      tmpfiles.settings."10-meshagent" = {
        "${folder}".d = {
          group = "root";
          mode = "0755";
          user = "root";
        };
        "${folder}/meshagent.msh".L = {
          argument = config.age.secrets.meshagent.path;
        };
      };

      services = {
        meshagent = {
          enable = true;
          description = "meshagent background service";
          wants = ["network-online.target"];
          after = ["network-online.target"];

          preStart = ''
            if [[ ! -f "${folder}/meshagent.db" ]]; then
              touch "${folder}/meshagent.db"
            fi
          '';

          script = "${pkgs.custom.mesh-agent}/bin/mesh-agent --installedByUser=0";

          serviceConfig = {
            WorkingDirectory = folder;
            # StandardOutput = "null";
            Restart = "on-failure";
            RestartSec = "5";
          };

          wantedBy = ["multi-user.target"];
          # aliases = ["meshagent.service"];
        };
      };
    };
  };
}
