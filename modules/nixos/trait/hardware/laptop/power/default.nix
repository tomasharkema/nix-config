{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.trait.hardware.laptop;
in {
  config = lib.mkIf cfg.enable {
    services.udev.extraRules = ''
      SUBSYSTEM=="power_supply", KERNEL=="AC", ATTR{online}=="0", RUN+="${pkgs.systemd}/bin/systemctl start battery.target"
      SUBSYSTEM=="power_supply", KERNEL=="AC", ATTR{online}=="1", RUN+="${pkgs.systemd}/bin/systemctl stop battery.target"
      SUBSYSTEM=="power_supply", KERNEL=="AC", ATTR{online}=="1", RUN+="${pkgs.systemd}/bin/systemctl start acpower.target"
      SUBSYSTEM=="power_supply", KERNEL=="AC", ATTR{online}=="0", RUN+="${pkgs.systemd}/bin/systemctl stop acpower.target"
    '';

    systemd = {
      services = {
        "beesd@root" = {
          unitConfig = {
            ConditionACPower = true;
          };

          wantedBy = ["acpower.target"];
          partOf = ["acpower.target"];
        };
        # "btrbk-${config.networking.hostName}-btrbk" = {
        #   unitConfig = {
        #     ConditionACPower = true;
        #   };

        #   wantedBy = ["acpower.target"];
        #   partOf = ["acpower.target"];
        # };
        # "nh-clean" = {
        #   unitConfig = {
        #     ConditionACPower = true;
        #   };
        #   wantedBy = ["acpower.target"];
        #   partOf = ["acpower.target"];
        # };
        # "nix-optimise" = {
        #   unitConfig = {
        #     ConditionACPower = true;
        #   };
        #   wantedBy = ["acpower.target"];
        #   partOf = ["acpower.target"];
        # };
        # "nix-gc" = {
        #   unitConfig = {
        #     ConditionACPower = true;
        #   };
        #   wantedBy = ["acpower.target"];
        #   partOf = ["acpower.target"];
        # };
      };

      targets = {
        sleep.enable = true;
        suspend.enable = true;
        hibernate.enable = true;
        hybrid-sleep.enable = true;

        battery = {
          enable = true;
          unitConfig = {
            DefaultDependencies = "no";
            StopWhenUnneeded = "yes";
          };
          # preStart = ''
          #   ${pkgs.coreutils}/bin/sleep 5
          # '';
        };
        acpower = {
          enable = true;
          unitConfig = {
            DefaultDependencies = "no";
            StopWhenUnneeded = "yes";
          };
          # preStart = ''
          #   ${pkgs.coreutils}/bin/sleep 5
          # '';
        };
      };
    };
  };
}
