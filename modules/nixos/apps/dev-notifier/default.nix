{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.gui.enable {
    systemd.user.services = {
      "dev-notifier" = {
        description = "dev-notifier";
        script = "${lib.getExe pkgs.custom.dev-notifier} -f";

        after = ["network.target"];
        reloadTriggers = ["on-failure"];
        wantedBy = ["default.target"];
      };
    };
  };
}
