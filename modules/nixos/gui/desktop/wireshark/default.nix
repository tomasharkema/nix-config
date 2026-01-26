{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  cfg = config.gui.desktop;
in {
  config = lib.mkIf cfg.enable {
    programs.wireshark = {
      enable = true;
      usbmon.enable = true;
      dumpcap.enable = true;

      package = pkgs.wireshark.overrideAttrs (
        finalAttrs: prevAttrs: {
          postInstall =
            prevAttrs.postInstall
            + ''
              local files="${pkgs.custom.nrf52840-mdk-usb-dongle}/lib/wireshark/extcap"
              mkdir -p "$out/lib/wireshark/extcap"

              for filename in $files/*; do
                local name="$(basename $filename)"
                echo "destination $out/libexec/wireshark/extcap/$name"
                ln -s "$filename" "$out/libexec/wireshark/extcap/$name"
              done
            '';
        }
      );
    };
  };
}
