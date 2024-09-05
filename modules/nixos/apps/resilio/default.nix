{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.apps.resilio;
  known_host = "100.120.66.165:52380";

  root = "/mnt/resilio-sync";

  debugTxt = pkgs.writeText "debug.txt" ''
    80000000
    0
  '';
in {
  options.apps.resilio = {
    enable = (lib.mkEnableOption "Enable preconfigured resilio service") // {default = true;};
    # root = mkOpt types.str "/mnt/resilio-sync" "root";

    enableEnc = lib.mkEnableOption "Enable enc";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [acl];

    systemd = {
      tmpfiles.rules = [
        "d ${root} 0777 rslsync rslsync -"
        "Z ${root} 0777 rslsync rslsync"
        "d /var/lib/resilio-sync 0777 rslsync rslsync -"
        "L+ /var/lib/resilio-sync/debug.txt - - - - ${debugTxt}"
        "L+ /home/tomas/resilio-sync - - - - ${root}"
      ];
    };

    systemd.services.resilio.serviceConfig.Nice = 14;

    age.secrets = {
      "resilio-p" = lib.mkIf (!cfg.enableEnc) {
        rekeyFile = ./resilio-p.age;
        mode = "644";
      };

      "resilio-p-enc" = lib.mkIf cfg.enableEnc {
        rekeyFile = ./resilio-p-enc.age;
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
      sharedFolders =
        [
          {
            directory = "${root}/shared-documents";
            searchLAN = true;
            secretFile = config.age.secrets."resilio-docs".path;
            useDHT = false;
            useRelayServer = false;
            useSyncTrash = true;
            useTracker = true;
            knownHosts = [known_host];
          }
          {
            directory = "${root}/shared-public";
            searchLAN = true;
            secretFile = config.age.secrets."resilio-shared-public".path;
            useDHT = false;
            useRelayServer = false;
            useSyncTrash = false;
            useTracker = true;
            knownHosts = [known_host];
          }
        ]
        ++ (lib.optional cfg.enableEnc {
          directory = "${root}/P-dir-enc";
          searchLAN = true;
          secretFile = config.age.secrets."resilio-p-enc".path;
          useDHT = false;
          useRelayServer = false;
          useSyncTrash = false;
          useTracker = true;
          knownHosts = [known_host];
        })
        ++ (lib.optional (!cfg.enableEnc) {
          directory = "${root}/P-dir";
          searchLAN = true;
          secretFile = config.age.secrets."resilio-p".path;
          useDHT = false;
          useRelayServer = false;
          useSyncTrash = false;
          useTracker = true;
          knownHosts = [known_host];
        });
    };
  };
}
