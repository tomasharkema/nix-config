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

    environment.etc = {
      "nixos.json".source = config.system.build.releaseJson;
      "mackerel-agent/conf.d/plugins.conf".text = ''
        [plugin.metrics.nvidia-smi]
        command = "${pkgs.custom.mackerel-plugin-nvidia-smi}/bin/mackerel-plugin-nvidia-smi"

        [plugin.checks.check_cron]
        command = [ "${pkgs.custom.mackerel-check-plugins}/bin/check-procs", "-p", "crond" ]

        [plugin.checks.check_sssd]
        command = [ "${pkgs.custom.mackerel-check-plugins}/bin/check-procs", "-p", "sssd" ]

        [plugin.metadata.nixos]
        command = "cat /etc/nixos.json"
      '';
    };

    services.mackerel-agent = {
      enable = true;
      apiKeyFile = config.age.secrets.mak.path;
      settings = {};
    };
  };
}
