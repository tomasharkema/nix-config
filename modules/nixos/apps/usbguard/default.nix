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

  config = {
    environment.systemPackages = with pkgs; [
      usbguard-notifier
      # config.nur.repos.mloeper.usbguard-applet-qt
      custom.usbguard-gnome
      usbguard-generate-rules
    ];

    systemd.packages = [pkgs.usbguard-notifier];

    system.activationScripts.usbguard-rules = ''
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

    services = {
      usbguard = {
        enable = lib.mkDefault true;
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
