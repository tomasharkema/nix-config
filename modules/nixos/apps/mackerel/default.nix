{
  config,
  pkgs,
  lib,
  ...
}: {
  config = {
    system = {
      build.releaseJson = pkgs.writers.writeJSON "nixos.json" config.system.nixos;
    };

    environment.etc."nixos.json".source = config.system.build.releaseJson;

    services.mackerel-agent = {
      enable = true;
      apiKeyFile = config.age.secrets.mak.path;
      settings = {
        "plugin.metrics.nvidia-smi" = {
          command = "${pkgs.custom.mackerel-plugin-nvidia-smi}/bin/mackerel-plugin-nvidia-smi";
        };
        "plugin.checks.check_cron" = {
          command = "${builtins.toJSON ["${pkgs.custom.mackerel-check-plugins}/bin/check-procs" "-p" "crond"]}";
        };
        "plugin.checks.check_sssd" = {
          command = "${builtins.toJSON ["${pkgs.custom.mackerel-check-plugins}/bin/check-procs" "-p" "sssd"]}";
        };
        "plugin.metadata.nixos" = {
          command = "cat /etc/nixos.json";
        };
      };
    };
  };
}
