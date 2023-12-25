{
  config,
  lib,
  ...
}: let
  known_host = "100.120.66.165:52380";
in {
  age.secrets."resilio-p" = {file = ../secrets/resilio-p.age;};
  age.secrets."resilio-docs" = {file = ../secrets/resilio-docs.age;};
  age.secrets."resilio-shared-public" = {file = ../secrets/resilio-shared-public.age;};

  system.activationScripts.resilioFolder = lib.mkIf config.services.resilio.enable ''
    if [ ! -d "/resilio-sync" ]; then
      rm -rf /var/lib/resilio-sync/shared-documents || true
      rm -rf /var/lib/resilio-sync/P-dir || true
      rm -rf /var/lib/resilio-sync/shared-public || true

      mkdir -p /resilio-sync || true

      chown -R rslsync:rslsync /resilio-sync/.
      chmod -R g+s /resilio-sync/.
      setfacl -d -m group:rslsync:rwx /resilio-sync/.
      setfacl -m group:rslsync:rwx /resilio-sync/.

      ln -s /resilio-sync/ /home/tomas/resilio-sync
    fi
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
