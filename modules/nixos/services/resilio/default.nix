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
in {
  options.resilio = {
    enable = mkBoolOpt true "Enable preconfigured resilio service";
    root = mkOpt types.str "/opt/resilio-sync" "root";
  };

  config = lib.mkIf cfg.enable {
    # age.secrets."resilio-p" = {file = ../secrets/resilio-p.age;};
    # age.secrets."resilio-docs" = {file = ../secrets/resilio-docs.age;};
    # age.secrets."resilio-shared-public" = {file = ../secrets/resilio-shared-public.age;};
    environment.systemPackages = with pkgs; [acl];

    systemd = {
      tmpfiles.rules = [
        "d '${config.resilio.root}' 0777 rslsync rslsync -"
        "Z '${config.resilio.root}' 0777 rslsync rslsync"
        # "d '/var/lib/resilio-sync' 0777 rslsync rslsync -"
        # "Z '/var/lib/resilio-sync' 0777 rslsync rslsync"
        "f '/var/lib/resilio-sync/debug.txt' 0600 rslsync rslsync - \"80000000\n0\""
        "L+ '${config.resilio.root}' - - - - '/home/tomas/resilio-sync'"
      ];
    };

    services.resilio = {
      enable = true;
      sharedFolders = [
        {
          directory = "${config.resilio.root}/shared-documents";
          searchLAN = true;
          secretFile = config.age.secrets."resilio-docs".path;
          useDHT = false;
          useRelayServer = true;
          useSyncTrash = true;
          useTracker = true;
          knownHosts = [known_host];
        }
        {
          directory = "${config.resilio.root}/P-dir";
          searchLAN = true;
          secretFile = config.age.secrets."resilio-p".path;
          useDHT = false;
          useRelayServer = true;
          useSyncTrash = false;
          useTracker = true;
          knownHosts = [known_host];
        }
        {
          directory = "${config.resilio.root}/shared-public";
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
