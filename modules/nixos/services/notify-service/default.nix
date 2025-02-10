{
  config,
  pkgs,
  lib,
  ...
}: let
  notifyServiceName = "notify-service";

  ntfyScript = pkgs.writeShellScript "ntfy-script" ''
    ${pkgs.ntfy-sh}/bin/ntfy publish --title "$HOSTNAME Status of $1" "$NIXOS_TOPIC_NAME" "$(systemctl status --full $1)"
  '';
in {
  # options.systemd.services = lib.mkOption {
  #   type = with lib.types;
  #     attrsOf (submodule {
  #       config.onFailure = ["${notifyServiceName}@%n.service"];
  #     });
  # };

  config = {
    # services.atd = {
    #   enable = true;
    #   allowEveryone = true;
    # };

    # systemd.services = {
    #   "${notifyServiceName}@" = {
    #     description = "Send onFailure Notification";
    #     onFailure = lib.mkForce [];
    #     path = [pkgs.bash];
    #     serviceConfig = {
    #       Type = "oneshot";
    #       EnvironmentFile = config.age.secrets."notify-sub".path;
    #       ExecStart = "${ntfyScript} %i";
    #     };
    #     wantedBy = ["default.target"];
    #     after = ["network-online.target"];
    #     wants = ["network-online.target"];
    #   };
    # };
  };
}
