{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib,
  # An instance of `pkgs` with your overlays and packages applied is also available.
  pkgs,
  # You also have access to your flake's inputs.
  inputs,
  # Additional metadata is provided by Snowfall Lib.
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.
  # All other arguments come from the module system.
  config,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.resilio;
  known_host = "100.120.66.165:52380";
in {
  options.resilio = {
    enable = mkBoolOpt true "SnowflakeOS GNOME configuration";
    root = mkOpt types.str "/resilio-sync" "root";
  };

  config = lib.mkIf cfg.enable {
    # age.secrets."resilio-p" = {file = ../secrets/resilio-p.age;};
    # age.secrets."resilio-docs" = {file = ../secrets/resilio-docs.age;};
    # age.secrets."resilio-shared-public" = {file = ../secrets/resilio-shared-public.age;};

    system.activationScripts.resilioFolder = ''
      if [ ! -d "${config.resilio.root}" ]; then

        mkdir -p "${config.resilio.root}" || true

        chown -R rslsync:rslsync "${config.resilio.root}/."
        chmod -R g+s "${config.resilio.root}/."
        setfacl -d -m group:rslsync:rwx "${config.resilio.root}/."
        setfacl -m group:rslsync:rwx "${config.resilio.root}/."

        ln -s "${config.resilio.root}/" /home/tomas/resilio-sync
      fi
    '';

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
          useSyncTrash = true;
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
