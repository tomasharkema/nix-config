{
  pkgs,
  lib,
  config,
  ...
}: let
  crashDir = "/var/crash";
in {
  config = {
    boot = {
      kernelParams = [
        #"efi_pstore.pstore_disable=0"
        "crashkernel=512M"
        "fadump=on"
        "nmi_watchdog=panic"
        "softlockup_panic=1"
      ];
      kernelModules = [
        "efi_pstore"
        "ramoops"
      ];
      initrd.kernelModules = [
        "efi_pstore"
        "ramoops"
      ];
    };

    environment.etc."kdump.conf".text = ''
      nfs 192.168.1.102:/volume1/tomas/crashdump
      auto_reset_crashkernel yes
      core_collector ${pkgs.makedumpfile}/bin/makedumpfile -l --message-level 7 -d 31
      path ${crashDir}
    '';

    systemd = {
      tmpfiles.settings."10-crash" = {
        "${crashDir}".d = {
          user = "root";
          group = "root";
          mode = "0755";
        };
      };
      services.kdump = {
        description = "Crash recovery kernel arming";
        after = ["network.target" "network-online.target" "remote-fs.target" "basic.target"];
        unitConfig = {
          DefaultDependencies = "no";
        };
        serviceConfig = {
          Type = "oneshot";
          ExecCondition = ''
            /bin/sh -c 'grep -q -e "crashkernel" -e "fadump" /proc/cmdline'
          '';
          ExecStart = "${pkgs.kdump-utils}/bin/kdumpctl start";
          ExecStop = "${pkgs.kdump-utils}/bin/kdumpctl stop";
          ExecReload = "${pkgs.kdump-utils}/bin/kdumpctl reload";
          RemainAfterExit = "yes";
          StartLimitInterval = "0";
          KeyringMode = "shared";
        };
        wantedBy = ["multi-user.target"];
      };
    };
  };
}
