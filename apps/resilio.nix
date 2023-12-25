{
  config,
  lib,
  ...
}: let
  known_host = "100.120.66.165:52380";
in {
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
  age.secrets."resilio-p" = {file = ../secrets/resilio-p.age;};
  age.secrets."resilio-docs" = {file = ../secrets/resilio-docs.age;};
  age.secrets."resilio-shared-public" = {file = ../secrets/resilio-shared-public.age;};

  config.system.activationScripts.makeVaultWardenDir = lib.stringAfter ["var"] ''
    rm -rf /var/lib/resilio-sync/shared-documents || true
    rm -rf /var/lib/resilio-sync/P-dir || true
    rm -rf /var/lib/resilio-sync/shared-public || true

    mkdir -p /resilio-sync || true

    chown -R rslsync:rslsync /resilio-sync
    chmox -R 777 /resilio-sync
  '';

  services.resilio = {
    enable = true;
    sharedFolders = [
      {
        directory = "/resilio-sync/shared-documents";
        searchLAN = true;
        secretFile = config.age.secrets."resilio-docs".path;
        useDHT = false;
        useRelayServer = true;
        useSyncTrash = true;
        useTracker = true;
        knownHosts = [known_host];
      }
      {
        directory = "/resilio-sync/P-dir";
        searchLAN = true;
        secretFile = config.age.secrets."resilio-p".path;
        useDHT = false;
        useRelayServer = true;
        useSyncTrash = true;
        useTracker = true;
        knownHosts = [known_host];
      }
      {
        directory = "/resilio-sync/shared-public";
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
}
