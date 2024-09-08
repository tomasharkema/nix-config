{
  pkgs,
  config,
  lib,
  ...
}: let
  usbguard-generate-rules = pkgs.writeShellScriptBin "usbguard-generate-rules" ''
    usbguard --generate-rules --output-file "${config.services.usbguard.ruleFile}"
  '';
in {
  config = {
    environment.systemPackages = with pkgs; [
      usbguard-notifier
      config.nur.repos.mloeper.usbguard-applet-qt
      usbguard-generate-rules
    ];

    system.activationScripts.usbguard-rules = ''
      if [ ! -f "${config.services.usbguard.ruleFile}" ]; then
        echo "Please create the rules file by running: usbguard-generate-rules"
      fi
    '';

    services = {
      usbguard = {
        enable = true;
        dbus.enable = true;
        # ruleFile
        # package
        # restoreControllerDeviceState
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
