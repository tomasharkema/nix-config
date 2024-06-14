{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.apps.sunshine;
  configFile = pkgs.writeTextDir "config/sunshine.conf" ''
    origin_web_ui_allowed=wan
  '';
in {
  options.apps.sunshine = { enable = mkEnableOption "sunshine"; };
  config = mkIf (cfg.enable && false) {
    # Sunshine user, service and config
    users.users.sunshine = {
      isNormalUser = true;
      linger = true;
      home = "/home/sunshine";
      description = "Sunshine Server";
      extraGroups = [ "wheel" "networkmanager" "input" "video" "sound" ];

      openssh.authorizedKeys.keyFiles = [ pkgs.custom.authorized-keys ];
    };

    security.sudo.extraRules = [{
      users = [ "sunshine" ];
      commands = [{
        command = "ALL";
        options = [ "NOPASSWD" ];
      }];
    }];

    security.wrappers.sunshine = {
      owner = "root";
      group = "root";
      capabilities = "cap_sys_admin+p";
      source = "${pkgs.sunshine}/bin/sunshine";
    };

    # Inspired from https://github.com/LizardByte/Sunshine/blob/5bca024899eff8f50e04c1723aeca25fc5e542ca/packaging/linux/sunshine.service.in
    systemd.user.services.sunshine = {
      enable = true;
      description = "Sunshine server";
      wantedBy = [ "graphical-session.target" ];
      startLimitIntervalSec = 500;
      startLimitBurst = 5;
      partOf = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];

      serviceConfig = {
        ExecStart =
          "${config.security.wrapperDir}/sunshine ${configFile}/config/sunshine.conf";
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };

    # services.xserver = {
    #   # Dummy screen
    #   monitorSection = ''
    #     VendorName     "Unknown"
    #     HorizSync   30-85
    #     VertRefresh 48-120

    #     ModelName      "Unknown"
    #     Option         "DPMS"
    #   '';

    #   deviceSection = ''
    #     VendorName "NVIDIA Corporation"
    #     Option      "AllowEmptyInitialConfiguration"
    #     Option      "ConnectedMonitor" "DFP"
    #     Option      "CustomEDID" "DFP-0"

    #   '';

    #   screenSection = ''
    #     DefaultDepth    24
    #     Option      "ModeValidation" "AllowNonEdidModes, NoVesaModes"
    #     Option      "MetaModes" "1920x1080"
    #     SubSection     "Display"
    #         Depth       24
    #     EndSubSection
    #   '';
    # };

    # Required to simulate input
    boot.kernelModules = [ "uinput" ];

    # Maybe not necessary ? udev rules are ignored with ssh ?
    services.udev.extraRules = ''
      KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
    '';
  };
}
