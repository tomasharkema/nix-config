{ pkgs, config, lib, ... }:
with lib;
let cfg = config.apps.cec;
in {
  options.apps.cec = { enable = mkEnableOption "cec"; };

  config = mkIf cfg.enable {
    # an overlay to enable raspberrypi support in libcec, and thus cec-client
    nixpkgs.overlays = [
      # nixos-22.05
      # (self: super: { libcec = super.libcec.override { inherit (self) libraspberrypi; }; })
      # nixos-22.11
      (self: super: {
        libcec = super.libcec.override { withLibraspberrypi = true; };
      })
    ];

    # install libcec, which includes cec-client (requires root or "video" group, see udev rule below)
    # scan for devices: `echo 'scan' | cec-client -s -d 1`
    # set pi as active source: `echo 'as' | cec-client -s -d 1`
    environment.systemPackages = with pkgs; [ libcec ];

    services.udev.extraRules = ''
      # allow access to raspi cec device for video group (and optionally register it as a systemd device, used below)
      KERNEL=="vchiq", GROUP="video", MODE="0660", TAG+="systemd", ENV{SYSTEMD_ALIAS}="/dev/vchiq"
    '';

    # optional: attach a persisted cec-client to `/run/cec.fifo`, to avoid the CEC ~1s startup delay per command
    # scan for devices: `echo 'scan' > /run/cec.fifo ; journalctl -u cec-client.service`
    # set pi as active source: `echo 'as' > /run/cec.fifo`
    systemd = {
      sockets."cec-client" = {
        after = [ "dev-vchiq.device" ];
        bindsTo = [ "dev-vchiq.device" ];
        wantedBy = [ "sockets.target" ];
        socketConfig = {
          ListenFIFO = "/run/cec.fifo";
          SocketGroup = "video";
          SocketMode = "0660";
        };
      };
      services."cec-client" = {
        after = [ "dev-vchiq.device" ];
        bindsTo = [ "dev-vchiq.device" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.libcec}/bin/cec-client -d 1";
          ExecStop = ''/bin/sh -c "echo q > /run/cec.fifo"'';
          StandardInput = "socket";
          StandardOutput = "journal";
          Restart = "no";
        };
      };
    };
  };
}
