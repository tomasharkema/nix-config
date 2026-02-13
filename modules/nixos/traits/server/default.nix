{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.traits.server;
in {
  options.traits.server = {
    enable = lib.mkEnableOption "server";

    headless.enable = lib.mkEnableOption "server headless";
  };

  config = lib.mkIf cfg.enable {
    system.nixos.tags = ["server"];

    services = {
      hypervisor = {
        enable = true;
        webservices.enable = true;
      };
      openvscode-server = {
        enable = true;
        host = "0.0.0.0";
        port = 3333;
        user = "tomas";
      };
      vscode-server = {
        enable = true;
        enableFHS = false;
        installPath = [
          "$HOME/.vscode-server"
          "$HOME/.vscode-server-oss"
          "$HOME/.vscode-server-insiders"
        ];
      };

      fail2ban = {
        enable = true;

        maxretry = 10;
        ignoreIP = [
          "10.0.0.0/8"
          "172.16.0.0/12"
          "192.168.0.0/16"
          "100.0.0.0/8"
        ];
        bantime = "24h"; # Ban IPs for one day on the first ban
        bantime-increment = {
          enable = true; # Enable increment of bantime after each violation
          formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
          #multipliers = "1 2 4 8 16 32 64";
          maxtime = "168h"; # Do not ban for more than 1 week
          overalljails = true; # Calculate the bantime based on all the violations
        };
      };
    };

    environment.etc = {
      "fail2ban/action.d/ntfy.local".text = pkgs.lib.mkDefault (pkgs.lib.mkAfter ''
        [Definition]
        norestored = true # Needed to avoid receiving a new notification after every restart
        actionban = curl -H "Title: <ip> has been banned" -d "<name> jail has banned <ip> from accessing $(hostname) after <failures> attempts of hacking the system." https://ntfy.sh/tomasharkema-nixos
      '');
    };

    disks.btrfs.swap.resume.enable = false;

    hardware = {
      nvidia = {
        # nvidiaPersistenced = true;
      };
    };

    apps.docker.enable = true;
    traits.server.headless.enable = true;
    boot = {
      tmp = {
        useTmpfs = true;
      };
      kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-server;
      # kernelPackages = pkgs.linuxPackages_6_12;
    };
  };
}
