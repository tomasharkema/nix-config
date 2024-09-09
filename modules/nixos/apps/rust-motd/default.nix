{
  pkgs,
  config,
  lib,
  ...
}: {
  config = {
    programs = {
      rust-motd = {
        enable = true;
        settings = {
          global = {
            progress_full_character = "=";
            progress_empty_character = "=";
            progress_prefix = "[";
            progress_suffix = "]";
            time_format = "%Y-%m-%d %H:%M:%S";
          };
          banner = {
            color = "red";
            command = "hostname | ${pkgs.figlet}/bin/figlet -f slant";
          };
          uptime = {
            prefix = "Up";
          };
          # weather = {
          #   url = "https://wttr.in/Amsterdam";
          # };
          service_status = {
            Accounts = "accounts-daemon";
            Attic-watch-store = "attic-watch-store";
          };
          filesystems = {
            root = "/";
          };
          memory = {
            swap_pos = "beside"; # or "below" or "none"
          };
          last_login = {
            tomas = 2;
          };
          last_run = {};
        };
      };
    };
  };
}
