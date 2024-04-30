{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.gui.icewm;
  iceConfig = pkgs.fetchzip {
    url = "https://github.com/ottop/blueicewm/archive/refs/tags/v1.0.tar.gz";
    hash = "sha256-UkUVtb2444YkztHJi1VacY4/dZDdkAHcScW9082tfoE=";
  };
in {
  options.gui.icewm = {
    enable = mkEnableOption "icewm";
  };
  config = mkIf cfg.enable {
    programs.hyprland = {
      # Install the packages from nixpkgs
      enable = true;
      # Whether to enable XWayland
      xwayland.enable = true;
    };

    services = {
      xserver = {
        enable = true;
        windowManager.icewm.enable = true;
        displayManager.defaultSession = lib.mkDefault "none+icewm";
      };

      xrdp = {
        enable = true;
        defaultWindowManager = "${pkgs.icewm}/bin/icewm-session";
      };
    };
    environment = {
      systemPackages = [pkgs.icewm];
      etc = {
        "icevm-theme" = {
          enable = true;
          source = "${iceConfig}/icewm";
          target = "icewm";
        };
      };
    };
  };
}
