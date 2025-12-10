{
  pkgs,
  config,
  lib,
  ...
}: let
  usbguard-generate-rules = pkgs.writeShellScriptBin "usbguard-generate-rules" ''
    sudo ${lib.getExe config.services.usbguard.package} generate-policy | sudo tee "${config.services.usbguard.ruleFile}"
  '';
in {
  options.apps.usbguard = {
    enable = lib.mkEnableOption "usbguard" // {default = true;};
  };

  config = lib.mkIf config.apps.usbguard.enable {
    environment.systemPackages = with pkgs; [
      usbguard-notifier
      # config.nur.repos.mloeper.usbguard-applet-qt
      custom.usbguard-gnome
      usbguard-generate-rules
      usbguard
    ];

    systemd.packages = with pkgs; [
      # usbguard
      # custom.usbguard-gnome
    ];

    system.activationScripts.usbguard-rules = lib.mkIf config.services.usbguard.enable ''
      if [ ! -f "${config.services.usbguard.ruleFile}" ]; then
        echo "Please create the rules file by running: usbguard-generate-rules"
      fi
    '';

    security.polkit = {
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if ((action.id == "org.usbguard.Policy1.listRules" ||
               action.id == "org.usbguard.Policy1.appendRule" ||
               action.id == "org.usbguard.Policy1.removeRule" ||
               action.id == "org.usbguard.Devices1.applyDevicePolicy" ||
               action.id == "org.usbguard.Devices1.listDevices" ||
               action.id == "org.usbguard1.getParameter" ||
               action.id == "org.usbguard1.setParameter") &&
               subject.active == true && subject.local == true &&
               subject.isInGroup("wheel")) { return polkit.Result.YES; }
        });
      '';
    };

    systemd.user.services = {
      usbguard-applet = {
        description = "USBGuard applet";
        partOf = ["graphical-session.target"];
        wantedBy = ["graphical-session.target"];
        path = ["/run/current-system/sw/"]; ### Fix empty PATH to find qt plugins
        after = [
          "dms.service"
          "usbguard.service"
          "graphical-session.target"
        ];
        # includes = ["dms.service"];
        serviceConfig = {
          ExecStart = "${pkgs.custom.usbguard-gnome}/bin/usbguard-gnome";
        };
      };
      usbguard-notifier = {
        description = "USBGuard Notifier";
        after = ["dms.service" "usbguard.service"];
        # includes = ["dms.service"];

        serviceConfig = {
          ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /tmp/usbguard-notifier";
          ExecStart = "${pkgs.usbguard-notifier}/bin/usbguard-notifier";
        };

        partOf = ["graphical-session.target"];

        wantedBy = ["graphical-session.target"];

        # wantedBy = ["default.target"];
      };
    };

    services = {
      dbus = {
        enable = true;
        packages = with pkgs; [
          custom.usbguard-gnome
          usbguard-notifier
          usbguard
        ];
      };
      usbguard = {
        enable = true;
        dbus.enable = true;
        # ruleFile
        # package
        restoreControllerDeviceState = true;
        # presentDevicePolicy
        # presentControllerPolicy
        # insertedDevicePolicy
        # implicitPolicyTarget
        # deviceRulesWithPort
        IPCAllowedUsers = [
          "tomas"
          "root"
        ];
        IPCAllowedGroups = [
          "tomas"
          "root"
          "plugdev"
        ];
      };
    };
  };
}
