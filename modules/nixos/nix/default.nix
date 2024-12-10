{
  options,
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    #   "${inputs.unstable}/nixos/modules/programs/nh.nix"
    ../../../nix-pkgs.nix
  ];

  config = let
    #   nix-otel = pkgs.nix-otel.overrideAttrs (final: {
    #     nix = config.nix.package;
    #   });
    pubKey = "tomas-nixos-1:attQnEt6Gq99mwz5J/h8EVhCpavuB0/z/u0Bt/Mko7E=";
  in {
    age.secrets = {
      "nix-sign-private" = {
        rekeyFile = ./nix-sign-private.age;
      };
    };

    # systemd.sockets.nix-supervisor = {
    #   socketConfig.ListenStream = [
    #     "/run/nix-supervisor.sock"
    #     "[::1]:9649"
    #   ];
    #   wantedBy = ["sockets.target"];
    # };

    documentation = {
      man = {
        enable = true;
        #          mandoc.enable = true;
        man-db.enable = true;
        # generateCaches = true;
      };
      dev.enable = true;
      doc.enable = true;
      info.enable = true;
      nixos = {
        enable = true;
        # includeAllModules = true;
      };
    };

    environment = {
      systemPackages = [
        pkgs.man-pages
        pkgs.man-pages-posix
      ];

      variables = {
        # OTEL_EXPORTER_OTLP_ENDPOINT = "http://localhost:8429/opentelemetry/v1/";
        # OTEL_EXPORTER_OTLP_LOGS_PROTOCOL = "http/proto";
        # OTEL_EXPORTER_OTLP_TRACES_PROTOCOL = "http/proto";
        # OTEL_EXPORTER_OTLP_METRICS_PROTOCOL = "http/proto";
      };
    };

    programs = {
      nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 4d --keep 3";
        flake = "/home/tomas/Developer/nix-config";
        package = pkgs.nh;
      };

      bash.undistractMe.enable = true;

      ccache = {
        enable = true;
        packageNames = [
          "sssd"
          "freeipa"
          # "mutter"
          # "gnome-shell"
          # "gnome-session"\
          "satyr"
          "libreport"
          "abrt"
          "gnome-abrt"
          "will-crash"
        ];
      };
    };

    systemd = {
      packages = with pkgs; [
        nix-web
      ];

      # Create a separate slice for nix-daemon that is
      # memory-managed by the userspace systemd-oomd killer
      slices."nix-daemon".sliceConfig = {
        ManagedOOMMemoryPressure = "kill";
        ManagedOOMMemoryPressureLimit = "50%";
      };
      services."nix-daemon".serviceConfig.Slice = "nix-daemon.slice";

      # If a kernel-level OOM event does occur anyway,
      #strongly prefer killing nix-daemon child processes
      services."nix-daemon".serviceConfig.OOMScoreAdjust = 1000;
    };

    nix = let
      users = [
        "root"
        config.user.name
      ];
    in {
      # package = pkgs.nixVersions.latest;

      # nixPath = [
      #   "nixpkgs=${inputs.nixpkgs}"
      #   "darwin=${inputs.darwin}"
      #   "home-manager=${inputs.home-manager}"
      # ];

      channel.enable = true;

      extraOptions = ''
        secret-key-files = ${config.age.secrets."nix-sign-private".path}
        min-free = ${toString (100 * 1024 * 1024)}
        max-free = ${toString (1024 * 1024 * 1024)}
      '';
      #  plugin-files = ${pkgs.nix-otel}/lib
      optimise.automatic = true;

      settings = {
        trusted-public-keys = [pubKey];

        extra-platforms = ["aarch64-linux" "i686-linux"];

        extra-sandbox-paths = [config.programs.ccache.cacheDir];

        use-cgroups = true;
        #  ca-derivations recursive-nix
        extra-experimental-features = "nix-command flakes cgroups";
        http-connections = 50;
        warn-dirty = false;
        log-lines = 50;
        sandbox = true;
        auto-optimise-store = true;
        trusted-users =
          users
          ++ [
            "tomas"
            "root"
          ];
        allowed-users =
          users
          ++ [
            "tomas"
            "root"
          ];
        netrc-file = config.age.secrets.netrc.path;
        keep-outputs = true;
        keep-derivations = true;
        # substituters =
        #   [cfg.default-substituter.url]
        #   ++ (mapAttrsToList (name: value: name) cfg.extra-substituters);
        # trusted-public-keys =
        #   [cfg.default-substituter.key]
        #   ++ (mapAttrsToList (name: value: value.key) cfg.extra-substituters);
      };

      # flake-utils-plus
      generateRegistryFromInputs = true;
      generateNixPathFromInputs = true;
      linkInputs = true;
    };
  };
}
