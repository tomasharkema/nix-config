{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  config = {
    services.dbus = {
      enable = true;
      packages = [pkgs.custom.ancs4linux];
    };

    users.groups.ancs4linux.members = ["root" "tomas"];

    systemd = {
      packages = [pkgs.custom.ancs4linux pkgs.unstable.packagekit];
      # services = {
      #   ancs4linux-observer.enable = true;
      #   ancs4linux-advertising.enable = true;
      # };
      # user.services.ancs4linux-desktop-integration.enable = true;
    };

    # systemctl daemon-reload

    # systemctl enable ancs4linux-observer.service
    # systemctl enable ancs4linux-advertising.service
    # systemctl --global enable ancs4linux-desktop-integration.service

    # systemctl restart ancs4linux-observer.service
    # systemctl restart ancs4linux-advertising.service
  };
}
# mkdir -p ~/.config/systemd/user/default.target.wants
# ln -s /run/current-system/sw/lib/systemd/user/syncthing.service ~/.config/systemd/user/default.target.wants/
# systemctl --user daemon-reload
# systemctl --user enable syncthing.service

