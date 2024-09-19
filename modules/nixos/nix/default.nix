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

  config =
    # let
    #   nix-otel = pkgs.nix-otel.overrideAttrs (final: {
    #     nix = config.nix.package;
    #   });
    # in
    {
      # systemd.packages = with pkgs; [nix-web];

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
          # mandoc.enable = true;
          man-db.enable = true;
          generateCaches = true;
        };
        dev.enable = true;
        doc.enable = true;
        info.enable = true;
        nixos = {
          enable = true;
        };
      };

      environment.variables = {
        # NIX_DAEMON_SOCKET_PATH = "/run/nix-supervisor.sock";
        # OTEL_EXPORTER_OTLP_ENDPOINT = "http://silver-star:5080/api/default/traces";
        # OTEL_EXPORTER_OTLP_HEADERS = "Authorization=\"Basic dG9tYXNAaGFya2VtYS5pbzpQdXIxN0RCb21CZVd4U0xV\"";
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
      };

      nix = let
        users =
          [
            "root"
            config.user.name
          ]
          ++ lib.optional config.services.hydra.enable "hydra";
      in {
        package = pkgs.nixVersions.nix_2_23; # .latest;

        nixPath = ["nixpkgs=${inputs.nixpkgs}"];

        channel.enable = true;

        extraOptions = ''
          min-free = ${toString (100 * 1024 * 1024)}
          max-free = ${toString (1024 * 1024 * 1024)}
        ''; # plugin-files = ${nix-otel}/lib

        optimise.automatic = true;

        settings = {
          extra-platforms = ["aarch64-linux" "i686-linux"];

          # extra-sandbox-paths = [config.programs.ccache.cacheDir];

          use-cgroups = true;
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
          #netrc-file = config.age.secrets.attic-netrc.path ++ config.age.secrets.netrc.path;
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
        # generateRegistryFromInputs = true;
        # generateNixPathFromInputs = true;
        # linkInputs = true;
      };
    };
}
