{
  pkgs,
  config,
  lib,
  ...
}:
with pkgs;
with lib;
with lib.custom; let
  cfg = config.services.go-nixos-dashboard;
in {
  options.services.go-nixos-dashboard = {
    enable = mkBoolOpt true "";
  };

  config = let
    go-nixos-dashboard-service = {
      enable = true;
      description = "go-nixos-dashboard";
      unitConfig = {
        Type = "notify";
      };
      serviceConfig = {
        RestartSec = 5;
        EnvironmentFile = config.age.secrets."go-nixos-menu.env".path;
      };
      script = "${lib.getExe go-nixos-menu} -v";
      wantedBy = ["multi-user.target"];
    };
  in
    mkIf cfg.enable {
      systemd.services = {
        go-nixos-dashboard = go-nixos-dashboard-service;
      };

      proxy-services.services = {
        "/dashboard/" = {
          proxyPass = "http://localhost:3333/";
        };
      };

      age.secrets."go-nixos-menu.env" = {
        file = ../../../../secrets/go-nixos-menu.env.age;
        mode = "644";
      };

      networking.nat = mkIf false {
        enable = true;
        internalInterfaces = ["ve-+"];
        # externalInterface = "ens3";
      };

      containers.go-nixos-menu = mkIf false {
        autoStart = true;
        privateNetwork = true;
        hostAddress = "192.168.100.10";
        localAddress = "192.168.100.11";

        config = {
          config,
          pkgs,
          ...
        }: {
          systemd.services = {
          };

          system.stateVersion = "23.11";

          networking = {
            firewall = {
              enable = true;
              allowedTCPPorts = [3333];
            };
            # Use systemd-resolved inside the container
            # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
            useHostResolvConf = mkForce false;
          };

          services.resolved.enable = true;
        };
      };
    };
}
