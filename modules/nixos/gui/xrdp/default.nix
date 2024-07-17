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
      audio.enable = true;

      # extraConfDirCommands = ''
      #   substituteInPlace $out/xrdp.ini \
      #     --replace "use_vsock=false" "use_vsock=true" \
      #     --replace "port=3389" "port=tcp://0.0.0.0:3389" \
      #     --replace "security_layer=negotiate" "security_layer=rdp" \
      #     --replace "crypt_level=high" "crypt_level=none"
      # '';

      # substituteInPlace $out/sesman.ini \
      #   --replace "X11DisplayOffset=10" "X11DisplayOffset=0"

      # package = pkgs.xrdp.overrideAttrs (oldAttrs: {
      #   configureFlags = oldAttrs.configureFlags ++ ["--enable-vsock"];
      # });
    };

    # systemd.services.xrdp = {
    #   serviceConfig = {
    #     ExecStart =
    #       lib.mkForce
    #       "${pkgs.xrdp}/bin/xrdp --nodaemon --config ${config.services.xrdp.confDir}/xrdp.ini";
    #   };
    # };
  };
}
