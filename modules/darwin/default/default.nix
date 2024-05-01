{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
# let
#   theme = inputs.themes.custom (inputs.themes.catppuccin-mocha
#     // {
#       base00 = "000000";
#     });
# in
{
  # options = {
  #   variables = lib.mkOption {
  #     type = lib.types.attrs;
  #     default = {
  #       theme = theme;
  #     };
  #   };
  # };

  imports = [
    inputs.agenix.darwinModules.default
    # ../../nixos/secrets
  ];

  config = {
    age = {
      identityPaths = [
        "/etc/ssh/ssh_host_ed25519_key"
        "/Users/tomas/.ssh/id_ed25519"
      ];

      secrets = {
        atuin = {
          file = ../../../secrets/atuin.age;
          # owner = "tomas";
          # group = "tomas";
          mode = "644";
          # symlink = false;
        };
        spotify-tui = {
          file = ../../../secrets/spotify-tui.age;
          # owner = "tomas";
          # group = "tomas";
          mode = "644";
          # symlink = false;
        };
        notify = {
          file = ../../../secrets/notify.age;
          # owner = "tomas";
          # group = "tomas";
          mode = "644";
          # symlink = false;
        };
      };
    };

    # programs.bash.enable = true;
    environment.systemPackages = with pkgs.custom; [menu];
    system.stateVersion = 4;

    services = {
      synergy.server = {
        enable = true;
      };
      nix-daemon.enable = true;
    };
    fonts = {
      fontDir.enable = true;
      fonts = with pkgs; [
        noto-fonts
        noto-fonts-extra
        noto-fonts-emoji
        noto-fonts-cjk
        nerdfonts
        terminus-nerdfont
        ubuntu_font_family

        pkgs.custom.neue-haas-grotesk

        # helvetica
        vegur # the official NixOS font
        pkgs.custom.b612
        inter
      ];
    };
    programs.zsh = {
      enable = true;
      # shellInit = ''
      #   export OP_PLUGIN_ALIASES_SOURCED=1
      # '';

      # shellAliases = {
      #   gh = "op plugin run -- gh";
      #   cachix = "op plugin run -- cachix";
      # };
    };
    # programs.fzf.fuzzyCompletion = true;
    nix = {
      # auto-optimise-store = true
      extraOptions = ''
        builders-use-substitutes = true
      '';

      trusted-users = ["root" "tomas"];
      # netrc-file = "/etc/nix/netrc";

      substituters = [
        "https://nix-gaming.cachix.org"
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
        "https://blue-fire.ling-lizard.ts.net/attic/tomas/"
        "https://devenv.cachix.org"
        "https://tomasharkema.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "peerix-tomas-1:OBFTUNI1LIezxoFStcRyCHKi2PHExoIcZA0Mfq/4uJA="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "tomas:qzaaV24nfgwcarekICaYr2c9ZBFDQnvvydOywbwAeys="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "tomasharkema.cachix.org-1:BV3Sv3qGZ0bcybPFeigwKoxnpj/NBAFYHq9FMO1XgH4="
      ];

      binaryCaches = ["https://cache.nixos.org"];

      distributedBuilds = true;

      # buildMachines = [
      #   {
      #     hostName = "builder@blue-fire";
      #     systems = ["x86_64-linux" "i686-linux" "aarch64-linux"];
      #     maxJobs = 2;
      #     supportedFeatures = ["kvm" "benchmark" "big-parallel"];
      #     speedFactor = 50;
      #   }
      #   {
      #     hostName = "builder@enzian";
      #     systems = ["x86_64-linux" "i686-linux" "aarch64-linux"];
      #     maxJobs = 2;
      #     supportedFeatures = ["kvm" "benchmark" "big-parallel"];
      #     speedFactor = 10;
      #   }
      #   # {
      #   #   hostName = "builder@wodan-wsl";
      #   #   systems = ["x86_64-linux" "i686-linux" "aarch64-linux"];
      #   #   maxJobs = 2;
      #   #   supportedFeatures = ["kvm" "benchmark" "big-parallel"];
      #   #   speedFactor = 100;
      #   # }
      # ];
    };
  };
}
