{
  pkgs,
  config,
  lib,
  ...
}:
with pkgs; let
  cfg = config.services.command-center;
in {
  options.services.command-center = {
    enable = lib.mkEnableOption "command-center" // {default = true;};
    enableBot = lib.mkEnableOption "command-center-bot";
  };

  # config = let
  #   command-center-service = {
  #     enable = true;
  #     description = "command-center";
  #     environment = { COMMAND_CENTER_RUN_BOT = mkIf cfg.enableBot "true"; };
  #     unitConfig = { Type = "notify"; };
  #     serviceConfig = {
  #       RestartSec = 5;
  #       EnvironmentFile = config.age.secrets."command-center.env".path;
  #     };
  #     script = "${lib.getExe command-center} -v";
  #     wantedBy = [ "multi-user.target" ];
  #   };
  # in mkIf cfg.enable {
  #   systemd.services = { command-center = command-center-service; };

  #   proxy-services.services = {
  #     "/dashboard/" = { proxyPass = "http://localhost:3456/"; };
  #   };

  #   age.secrets."command-center.env" = {
  #     file = ../../../../secrets/command-center.env.age;
  #     mode = "644";
  #   };

  #   networking.nat = mkIf false {
  #     enable = true;
  #     internalInterfaces = [ "ve-+" ];
  #     # externalInterface = "ens3";
  #   };

  #   containers.go-nixos-menu = mkIf false {
  #     autoStart = true;
  #     privateNetwork = true;
  #     hostAddress = "192.168.100.10";
  #     localAddress = "192.168.100.11";

  #     config = { config, pkgs, ... }: {
  #       systemd.services = { };

  #       system.stateVersion = "25.05";

  #       networking = {
  #         firewall = {
  #           enable = false;
  #           allowedTCPPorts = [ 3456 ];
  #         };
  #         # Use systemd-resolved inside the container
  #         # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
  #         useHostResolvConf = mkForce false;
  #       };

  #       services.resolved.enable = true;
  #     };
  #   };
  # };
}
