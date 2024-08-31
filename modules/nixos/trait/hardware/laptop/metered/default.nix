{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.trait.hardware.laptop;
in {
  config = mkIf cfg.enable {
    systemd = {
      services = {
        "unmetered-connection" = {
          description = "Check if the current connection is metered";
          path = [pkgs.dbus];
          script = ''
            metered_status=$(dbus-send --system --print-reply=literal \
                   	--system --dest=org.freedesktop.NetworkManager \
            	      /org/freedesktop/NetworkManager \
            	      org.freedesktop.DBus.Properties.Get \
            	      string:org.freedesktop.NetworkManager string:Metered \
            	      | grep -o ".$")

            if [[ $metered_status =~ (1|3) ]]; then
              echo Current connection is metered
              exit 1
            else
              exit 0
            fi
          '';
          serviceConfig = {
            Type = "oneshot";
          };
        };

        "btrbk-${config.networking.hostName}-btrbk" = {
          requires = ["unmetered-connection.service"];
          after = ["unmetered-connection.service"];
        };
        "attic-watch-store" = {
          requires = ["unmetered-connection.service"];
          after = ["unmetered-connection.service"];
        };
      };
    };
  };
}
