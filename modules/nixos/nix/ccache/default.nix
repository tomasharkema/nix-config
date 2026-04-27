{
  config,
  lib,
  pkgs,
  ...
}: let
  ccacheOptions = {
    INODECACHE = "true";
    COMPRESS = "true";
    DIR = "${config.programs.ccache.cacheDir}";
    UMASK = "002";
    SLOPPINESS = "locale,time_macros";
    MAXSIZE = "20GB";
    RESHARE = "true";
    REMOTE_STORAGE = "file:///mnt/cache/ccache";
    LOGFILE = "syslog";
  };

  withCcachePrefix = lib.mapAttrs' (name: value: lib.nameValuePair ("CCACHE_" + name) value) ccacheOptions;

  exportVariablesList =
    lib.mapAttrsToList (
      n: v: ''export ${n}="${v}"''
    )
    withCcachePrefix;

  exportVariables = lib.concatStringsSep "\n" exportVariablesList;
in {
  config = {
    nixpkgs.overlays = [
      (self: super: {
        ccacheWrapper = super.ccacheWrapper.override {
          extraConfig = builtins.trace "\n\n====\n\n${exportVariables}\n\n====\n\n" ''
            ${exportVariables}

            if [ ! -d "$CCACHE_DIR" ]; then
              echo "====="
              echo "Directory '$CCACHE_DIR' does not exist"
              echo "Please create it with:"
              echo "  sudo mkdir -m0777 '$CCACHE_DIR'"
              echo "  sudo chown root:nixbld '$CCACHE_DIR'"
              echo "====="
              exit 1
            fi
            if [ ! -w "$CCACHE_DIR" ]; then
              echo "====="
              echo "Directory '$CCACHE_DIR' is not accessible for user $(whoami)"
              echo "Please verify its access permissions"
              echo "====="
              exit 1
            fi
          '';
        };
      })
    ];

    environment = {
      systemPackages = [pkgs.ccache];
      variables = withCcachePrefix;

      etc."ccache.conf".text = ''
        max_size = 20G
        cache_dir = "${ccacheOptions.DIR}"
        compression = true
        reshare = true
        umask = 002
        inode_cache = true
        sloppiness = locale,time_macros
        remote_storage = "${ccacheOptions.REMOTE_STORAGE}"
        log_file = syslog
      '';
    };

    nix.settings.extra-sandbox-paths = [
      config.programs.ccache.cacheDir
      ccacheOptions.DIR
    ];

    fileSystems = {
      "/mnt/cache" = {
        device = "192.168.1.102:/volume1/cache";
        fsType = "nfs";
        options = [
          "x-systemd.automount"
          "noauto"
          "x-systemd.idle-timeout=600"
          "fsc"
        ];
      };
    };

    programs.ccache = {
      enable = true;
      packageNames = [
        # "sssd"
        # "freeipa"
      ];
    };
  };
}
