{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  config = mkIf config.gui.enable {
    services.xrdp = {
      enable = true;

      # confDir = "/etc/xrdp";

      package = pkgs.xrdp.overrideAttrs (oldAttrs: {
        configureFlags = oldAttrs.configureFlags ++ ["--enable-vsock"];

        postInstall =
          oldAttrs.postInstall
          + ''
            substituteInPlace $out/etc/xrdp/xrdp.ini \
              --replace "port=3389" "port=tcp://0.0.0.0:3389" \
              --replace "security_layer=negotiate" "security_layer=rdp" \
              --replace "crypt_level=high" "crypt_level=none" \
              --replace "bitmap_compression=true" "bitmap_compression=false"

            substituteInPlace $out/etc/xrdp/sesman.ini \
              --replace "X11DisplayOffset=10" "X11DisplayOffset=0" \
          '';
      });
    };

    systemd = {
      services.xrdp = {
        serviceConfig = {
          ExecStart = lib.mkForce "${pkgs.xrdp}/bin/xrdp --nodaemon --config ${config.services.xrdp.confDir}/xrdp.ini";
          # https://github.com/NixOS/nixpkgs/blob/nixos-23.11/nixos/modules/services/networking/xrdp.nix#L158
          # seems the integer port results in ipv6 only
        };
      };
    };
  };
}
