{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.apps.resilio;
  port = 52380;
  # known_host = "100.125.116.111:${builtins.toString port}";

  root = "/mnt/resilio-sync";

  runConfigPath = "/run/rslsync/config.json";
  # debugTxt = pkgs.writeText "debug.txt" ''
  #   00000000
  #   0
  # '';
in {
  options.apps.resilio = {
    enable = (lib.mkEnableOption "Enable preconfigured resilio service") // {default = true;};
    enableEnc = lib.mkEnableOption "Enable enc";
  };

  config = lib.mkIf (cfg.enable) {
    environment.systemPackages = with pkgs; [acl];

    systemd = {
      tmpfiles.rules = [
        # "d ${root} 0777 rslsync rslsync -"
        # "Z ${root} 0777 rslsync rslsync"
        # "d /var/lib/resilio-sync 0777 rslsync rslsync -"
        # "L+ /var/lib/resilio-sync/debug.txt - - - - ${debugTxt}"
        # "L+ /home/tomas/resilio-sync - - - - ${root}"
      ];
    };

    # systemd.services.resilio.serviceConfig.Nice = 14;

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
      "resilio-license" = {
        rekeyFile = ./resilio-license.age;
        mode = "644";
        owner = "rslsync";
        group = "rslsync";
        path = "/run/resilio-sync/license.btskey";
      };
    };

    networking.firewall = {
      allowedTCPPorts = [
        port
        52381
        3838
        1900
        5351
      ];
      allowedUDPPorts = [
        port
        52381
        3838
        1900
        5351
      ];
    };

    systemd.services.resilio.serviceConfig = {
      # LoadCredential = "resilio-license:${config.age.secrets."resilio-license".path}";
      ExecStartPre = [
        (pkgs.writeShellScript "createIdentity.sh" ''
          if [ ! -e "/var/lib/resilio-sync/License" ]; then
            echo "creating identity..."
            ${lib.concatStringsSep " " [
            (lib.getExe config.services.resilio.package)
            "--nodaemon"
            "--config ${runConfigPath}"
            "--license ${config.age.secrets."resilio-license".path}"
            "--identity ${config.networking.hostName}"
          ]}
          fi
        '')
      ];
      ExecStart = lib.mkForce (lib.concatStringsSep " " [
        (lib.getExe config.services.resilio.package)
        "--nodaemon"
        "--config ${runConfigPath}"
      ]);
    };

    users.users.tomas.extraGroups = ["rslsync"];

    services.resilio = {
      enable = true;
      listeningPort = port;
      # directoryRoot = root;
      checkForUpdates = false;
      sharedFolders =
        [
          {
            directory = "${root}/shared-documents";
            searchLAN = true;
            secretFile = config.age.secrets."resilio-docs".path;
            useDHT = true;
            useSyncTrash = true;
            useRelayServer = true;
            useTracker = true;
            # knownHosts = [known_host];
            knownHosts = [];
          }
        ]
        ++ (lib.optional cfg.enableEnc {
          directory = "${root}/P-dir-enc";
          searchLAN = true;
          secretFile = config.age.secrets."resilio-p-enc".path;
          useDHT = true;
          useSyncTrash = false;
          useRelayServer = true;
          useTracker = true;
          # knownHosts = [known_host];
          knownHosts = [];
        })
        ++ (lib.optional (!cfg.enableEnc) {
          directory = "${root}/P-dir";
          searchLAN = true;
          secretFile = config.age.secrets."resilio-p".path;
          useDHT = true;
          useSyncTrash = false;
          useRelayServer = true;
          useTracker = true;
          # knownHosts = [known_host];
          knownHosts = [];
        });
    };
  };
}
