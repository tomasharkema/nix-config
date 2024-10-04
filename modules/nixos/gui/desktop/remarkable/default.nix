{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf (config.gui.desktop.enable && false) {
    environment.systemPackages = with pkgs; [
      custom.remy
    ];

    home-manager.users.tomas.home.file = {
      ".config/remy/config.json" = {
        source = pkgs.writers.writeJSON "config.json" {
          "name" = "reMarkable (RSync)";
          "type" = "rsync";
          # "data_dir" = "/path-to/remy";
          "host" = "remarkable";
          "key" = "~/.ssh/id_rsa_remarkable";
          "username" = "root";
          "timeout" = 3;
          # "use_banner" = "remy-banner.png";
          "cache_mode" = "on_demand";
          "rsync_path" = "${pkgs.rsync}/bin/rsync";
          "rsync_options" = ["--rsync-path=/opt/bin/rsync"];
        };
      };
    };
  };
}
