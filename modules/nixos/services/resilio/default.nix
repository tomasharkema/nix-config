{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.resilio;
  known_host = "100.120.66.165:52380";

  root = "/mnt/resilio-sync";
in {
  options.resilio = {
    enable = mkBoolOpt true "Enable preconfigured resilio service";
    # root = mkOpt types.str "/mnt/resilio-sync" "root";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [acl];

    systemd = {
      tmpfiles.rules = [
        "d ${root} 0777 rslsync rslsync -"
        "Z ${root} 0777 rslsync rslsync"
        "d /var/lib/resilio-sync 0777 rslsync rslsync -"
        "f+ /var/lib/resilio-sync/debug.txt 0600 rslsync rslsync - 80000000\\n0"
        "L+ /home/tomas/resilio-sync - - - - ${root}"
      ];
    };

    systemd.services.resilio.serviceConfig.Nice = 19;

    age.secrets = {
      "resilio-p" = {
        rekeyFile = ./resilio-p.age;
        mode = "644";
      };

      "resilio-docs" = {
        rekeyFile = ./resilio-docs.age;
        mode = "644";
      };
      "resilio-shared-public" = {
        rekeyFile = ./resilio-shared-public.age;
        mode = "644";
      };
    };

    services.resilio = {
      enable = true;
      sharedFolders = [
        {
          directory = "${root}/shared-documents";
          searchLAN = true;
          secretFile = config.age.secrets."resilio-docs".path;
          useDHT = false;
          useRelayServer = true;
          useSyncTrash = true;
          useTracker = true;
          knownHosts = [known_host];
        }
        {
          directory = "${root}/P-dir";
          searchLAN = true;
          secretFile = config.age.secrets."resilio-p".path;
          useDHT = false;
          useRelayServer = true;
          useSyncTrash = false;
          useTracker = true;
          knownHosts = [known_host];
        }
        {
          directory = "${root}/shared-public";
          searchLAN = true;
          secretFile = config.age.secrets."resilio-shared-public".path;
          useDHT = false;
          useRelayServer = true;
          useSyncTrash = false;
          useTracker = true;
          knownHosts = [known_host];
        }
      ];
    };
  };
}
