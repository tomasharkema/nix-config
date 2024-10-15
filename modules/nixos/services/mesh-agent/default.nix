{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.meshagent;
  folder = "/usr/local/mesh_services/meshagent";
in {
  options.services.meshagent = {
    enable = (lib.mkEnableOption "meshagent") // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    age.secrets = {
      meshagent = {
        rekeyFile = ./msh.age;
      };
      meshid = {
        rekeyFile = ./meshid.age;
      };
    };

    systemd = {
      tmpfiles.settings."10-meshagent" = {
        "${folder}".d = {
          group = "root";
          mode = "0755";
          user = "root";
        };
        # "${folder}/meshagent.msh".L = {
        #   argument = config.age.secrets.meshagent.path;
        # };
        # "${folder}/meshagent".L = {
        #   argument = "${pkgs.custom.meshagent}/bin/meshagent";
        # };
      };

      services = {
        meshagent = {
          enable = true;
          description = "meshagent background service";
          wants = ["network-online.target"];
          after = ["network-online.target"];

          preStart = ''

            # /usr/bin/id -u

            if [[ ! -f "${folder}/meshagent.msh" ]]; then

              url="meshcentral.harkema.io"
              meshid="$(cat ${config.age.secrets.meshid.path})"
              starttype="1" # 1 = Systemd

              mkdir -p "${folder}"

              ${pkgs.wget}/bin/wget $url/meshagents?id=6 -O "${folder}/meshagent"
              chmod 755 "${folder}/meshagent"

              ${pkgs.wget}/bin/wget $url/meshsettings?id=$meshid -O "${folder}/meshagent.msh"

              # Remove all lines that start with "StartupType="
              sed '/^StartupType=/ d' < "${folder}/meshagent.msh" >> "${folder}/meshagent2.msh"
              # Add the startup type to the file
              echo "StartupType=$starttype" >> "${folder}/meshagent2.msh"
              mv "${folder}/meshagent2.msh" "${folder}/meshagent.msh"
              ${folder}/meshagent -fullinstall --copy-msh=1
            fi
          '';

          serviceConfig = {
            WorkingDirectory = folder;
            # StandardOutput = "null";
            Restart = "on-failure";
            RestartSec = "5";
            ExecStart = "${folder}/meshagent --installedByUser=0";
            BindReadOnlyPaths = [
              "/usr/bin:${pkgs.custom.meshagent.fhs}/bin"
            ];
          };

          wantedBy = ["multi-user.target"];
          # aliases = ["meshagent.service"];
        };
      };
    };
  };
}
