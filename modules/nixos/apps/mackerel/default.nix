{
  config,
  pkgs,
  lib,
  ...
}: {
  config = {
    environment = {
      systemPackages = with pkgs; [custom.mkr];

      etc = {
        "nixos.json".source = config.system.build.releaseJson;

        "mackerel-agent/conf.d/plugin-nvidia.conf" = lib.mkIf config.traits.hardware.nvidia.enable {
          text = ''
            [plugin.checks.nvidia-smi]
            command = "${config.system.build.mackerel-plugin-nvidia-smi}/bin/mackerel-plugin-nvidia-smi"
          '';
        };

        "mackerel-agent/conf.d/plugins.conf".text = ''

          [plugin.checks.check_sssd]
          command = [ "${pkgs.custom.mackerel-check-plugins}/bin/check-procs", "-p", "sssd" ]

          [plugin.checks.check_tailscaled]
          command = [ "${pkgs.custom.mackerel-check-plugins}/bin/check-procs", "-p", "tailscaled" ]

          [plugin.checks.check_systemd]
          command = "${pkgs.custom.mackerel-check-systemd}/bin/systemd-status"

          [plugin.metadata.nixos]
          command = "cat /etc/nixos.json"
        '';
      };
    };

    system.build = {
      releaseJson = pkgs.writers.writeJSON "nixos.json" config.system.nixos;
      mackerel-plugin-nvidia-smi = pkgs.custom.mackerel-plugin-nvidia-smi.override {
        nvidia = config.hardware.nvidia.package;
      };
    };

    services = {
      mackerel-agent = {
        enable = true;
        apiKeyFile = config.age.secrets.mak.path;
        settings = {
          verbose = true;
          silent = true;
          roles = ["nixos:server"];
        };
      };
      osquery.enable = true;
      grafana-agent = {enable = true;};
    };

    systemd.services.mackerel-agent = {
      restartTriggers = [
        config.environment.etc."nixos.json".source
        config.environment.etc."mackerel-agent/conf.d/plugins.conf".source
        "/etc/mackerel-agent/conf.d"
      ];
    };
  };
}
