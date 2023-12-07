{ config, pkgs, modulesPath, ... }: {

  #   deployment.keys."resilio.key" = {
  #     # Alternatively, `text` (string) or `keyFile` (path to file)
  #     # may be specified.
  #     keyCommand = [ "op" "item" "get" "shared docs key" "--fields" "password" ];
  #     destDir = "/run/resilio";
  #     user = "rslsync"; # Default: root
  #     group = "rslsync"; # Default: root
  #     # permissions = "0777"; # Default: 0600
  #     # permissions = "0777";
  #     uploadAt =
  #       "pre-activation"; # Default: pre-activation, Alternative: post-activation
  #   };
  #   deployment.keys."resilio_p.key" = {
  #     # Alternatively, `text` (string) or `keyFile` (path to file)
  #     # may be specified.
  #     keyCommand =
  #       [ "op" "item" "get" "shared docs key p" "--fields" "password" ];
  #     destDir = "/run/resilio";
  #     user = "rslsync"; # Default: root
  #     group = "rslsync"; # Default: root
  #     # permissions = "0777"; # Default: 0600
  #     # permissions = "0777";
  #     uploadAt =
  #       "pre-activation"; # Default: pre-activation, Alternative: post-activation
  #   };
  services.resilio = {
    enable = true;
    sharedFolders = [
      {
        directory = "/var/lib/resilio-sync/shared_documents";
        searchLAN = true;
        secretFile = "/run/resilio/resilio.key";
        useDHT = false;
        useRelayServer = true;
        useSyncTrash = true;
        useTracker = true;
        knownHosts = [ "100.120.66.165:52380" ];
      }
      {
        directory = "/var/lib/resilio-sync/P";
        searchLAN = true;
        secretFile = "/run/resilio/resilio_p.key";
        useDHT = false;
        useRelayServer = true;
        useSyncTrash = true;
        useTracker = true;
        knownHosts = [ "100.120.66.165:52380" ];
      }
    ];
  };
  systemd.services.resilio.wantedBy =
    [ "resilio.key-key.service" "resilio.key-key.path" ];

}
