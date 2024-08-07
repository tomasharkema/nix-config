{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.gui.quiet-boot;
in {
  options.gui.quiet-boot = {enable = mkEnableOption "quiet-boot enabled";};

  config = mkIf (cfg.enable) {
    console = {
      earlySetup = true;
    };

    environment.systemPackages = with pkgs; [plymouth];

    boot = {
      plymouth = {
        enable = true;
        # theme = "fedora-branded";
        # themePackages = [
        #   pkgs.custom.plymouth-progress
        # ];
      };
      loader.timeout = mkDefault 0;
      kernelParams = [
        "quiet"
        "loglevel=3"
        "systemd.show_status=auto"
        "udev.log_level=3"
        "rd.udev.log_level=3"
        "vt.global_cursor_default=0"
      ];
      consoleLogLevel = mkDefault 0;
      initrd = {
        systemd.enable = mkDefault true;
        verbose = mkDefault false;
      };
    };
  };
}
