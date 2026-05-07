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
  options = {
    apps._1password.gui.enable = lib.mkEnableOption "1password" // {default = true;};
  };

  config = {
    age = {
      rekey = {
        agePlugins = lib.mkForce [pkgs.age-plugin-yubikey];
      };
      secrets = {
        # atuin = {
        # rekeyFile = ../../nixos/secrets/atuin.age;
        # owner = "${config.user.name}";
        # group = "${config.user.name}";
        # mode = "666";
        # symlink = false;
        # };
        # spotify-tui = {
        # file = ../../../secrets/spotify-tui.age;
        # owner = "${config.user.name}";
        # group = "${config.user.name}";
        # mode = "644";
        # symlink = false;
        # };
        # notify = {
        # rekeyFile = ../../nixos/secrets/notify.age;
        # owner = "${config.user.name}";
        # group = "${config.user.name}";
        # mode = "644";
        # symlink = false;
        # };
      };
    };

    environment.systemPackages =
      (with pkgs.custom; [
        menu
        # nscan
      ])
      ++ (with pkgs; [
        # keep-sorted start
        agenix-rekey
        # custom.rust-conn
        alejandra
        devenv
        direnv
        lrzsz
        manix
        nh
        nil
        nix-search-cli
        # dosbox-x
        nixd
        nox
        yubico-piv-tool
        # keep-sorted end
      ]);

    environment.pathsToLink = [
      "/lib"
      "/share/zsh"
      "/share/fonts"
    ];

    system.stateVersion = 4;

    services = {
      # synergy.server = {
      #   enable = true;
      # };
      tailscale.enable = true;
    };

    fonts = {
      packages = with pkgs; [
        # keep-sorted start
        adwaita-fonts
        b612
        bakoma_ttf
        cm_unicode
        custom.computer-modern
        custom.din
        custom.fast-font
        custom.futura
        exult
        font-awesome
        google-fonts
        inter
        lmmath
        nerd-fonts.iosevka
        nerd-fonts.jetbrains-mono
        nerd-fonts.terminess-ttf
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        pkgs.custom.neue-haas-grotesk
        powerline-fonts
        powerline-symbols
        ubuntu-classic
        vegur
        # helvetica
        virglrenderer
        # keep-sorted end
      ];
    };

    programs = {
      zsh = {
        enable = true;
        # shellInit = ''
        #   export OP_PLUGIN_ALIASES_SOURCED=1
        # '';
      };
      bash.enable = true;
    };

    # programs.fzf.fuzzyCompletion = true;

    nix = {
      distributedBuilds = true;

      # auto-optimise-store = true

      extraOptions = ''
        builders-use-substitutes = true
      '';

      settings = {
        trusted-users = [
          "root"
          "tomas"
        ];

        # extra-substituters = [
        #   "https://nix-gaming.cachix.org"
        #   "https://nix-community.cachix.org"
        #   "https://nix-cache.harke.ma/tomas/"
        #   "https://devenv.cachix.org"
        #   "https://cuda-maintainers.cachix.org"
        # ];
        # extra-trusted-public-keys = [
        #   "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        #   "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        #   "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        #   "tomas:hER/5A08v05jH8GnQUZRrh33+HDNbeiJj8z/8JY6ZvI="
        #   "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        #   "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        # ];
      }; # netrc-file = "/etc/nix/netrc";

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
