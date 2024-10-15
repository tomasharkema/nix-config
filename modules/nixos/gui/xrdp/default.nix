{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.gui.rdp;
in {
  options.gui.rdp = {
    enable = lib.mkEnableOption "rdp";

    legacy = lib.mkEnableOption "rdp legacy";
  };

  config = lib.mkIf cfg.enable {
    systemd.services = {
      # sudo -u gnome-remote-desktop winpr-makecert \
      #     -silent -rdp -path ~gnome-remote-desktop rdp-tls
      # sudo grdctl --system rdp enable
      # sudo grdctl --system rdp set-credentials "${RDP_USER}" "${RDP_PASS}"
      # sudo grdctl --system rdp set-tls-key ~gnome-remote-desktop/rdp-tls.key
      # sudo grdctl --system rdp set-tls-cert ~gnome-remote-desktop/rdp-tls.crt

      "gnome-remote-desktop" = lib.mkIf (!cfg.legacy) {
        enable = true;
        wantedBy = [
          # "graphical-session.target"
          "graphical.target"
        ];
      };

      xrdp = lib.mkIf (cfg.legacy) {
        serviceConfig = {
          ExecStart =
            lib.mkForce
            "${pkgs.xrdp}/bin/xrdp --nodaemon --config ${config.services.xrdp.confDir}/xrdp.ini";
        };
      };
    };

    services.xrdp = lib.mkIf cfg.legacy {
      enable = true;
      audio.enable = true;

      extraConfDirCommands = ''
        substituteInPlace $out/xrdp.ini \
          --replace "use_vsock=false" "use_vsock=true" \
          --replace "port=3389" "port=tcp://0.0.0.0:3389" \
          --replace "security_layer=negotiate" "security_layer=rdp" \
          --replace "crypt_level=high" "crypt_level=none"
      '';

      # substituteInPlace $out/sesman.ini \
      #   --replace "X11DisplayOffset=10" "X11DisplayOffset=0"

      package = pkgs.xrdp.overrideAttrs (oldAttrs: {
        configureFlags = oldAttrs.configureFlags ++ ["--enable-vsock"];
      });
    };
  };
}
