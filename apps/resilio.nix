{ config, ... }: {
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
  age.secrets."resilio-p" = { file = ../secrets/resilio-p.age; };
  age.secrets."resilio-docs" = { file = ../secrets/resilio-docs.age; };
  age.secrets."resilio-shared-public" = { file = ../secrets/resilio-shared-public.age; };

  services.resilio = {
    enable = true;
    sharedFolders = [
      {
        directory = "/var/lib/resilio-sync/shared-documents";
        searchLAN = true;
        secretFile = config.age.secrets."resilio-docs".path;
        useDHT = false;
        useRelayServer = true;
        useSyncTrash = true;
        useTracker = true;
        knownHosts = [ "100.120.66.165:52380" ];
      }
      {
        directory = "/var/lib/resilio-sync/P-dir";
        searchLAN = true;
        secretFile = config.age.secrets."resilio-p".path;
        useDHT = false;
        useRelayServer = true;
        useSyncTrash = true;
        useTracker = true;
        knownHosts = [ "100.120.66.165:52380" ];
      }
      {
        directory = "/var/lib/resilio-sync/shared-public";
        searchLAN = true;
        secretFile = config.age.secrets."resilio-shared-public".path;
        useDHT = false;
        useRelayServer = true;
        useSyncTrash = true;
        useTracker = true;
        knownHosts = [ "100.120.66.165:52380" ];
      }
    ];
  };
}
