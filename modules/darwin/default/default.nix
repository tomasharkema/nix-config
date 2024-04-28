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
