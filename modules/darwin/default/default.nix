{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    inputs.agenix.darwinModules.default
    # ../../nixos/secrets
  ];

  config = {
    age.identityPaths = [
      # "/etc/ssh/ssh_host_ed25519_key"
      "/Users/tomas/.ssh/id_ed25519"
    ];
    age.secrets.atuin = {
      file = ../../../secrets/atuin.age;
      # owner = "tomas";
      # group = "tomas";
      mode = "644";
      # symlink = false;
    };

    services.nix-daemon.enable = true;

    system.stateVersion = 4;
    services.synergy.server = {
      enable = true;
      # serverAddress = "0.0.0.0";
    };

    fonts = {
      fontDir.enable = true;
      fonts = with pkgs; [
        noto-fonts
        noto-fonts-extra
        noto-fonts-emoji
        noto-fonts-cjk
        nerdfonts
        ubuntu_font_family

        pkgs.custom.neue-haas-grotesk

        # helvetica
        vegur # the official NixOS font
        pkgs.custom.b612
        pkgs.custom.san-francisco
      ];
    };
    programs.zsh = {
      enable = true;
      shellInit = ''
        export OP_PLUGIN_ALIASES_SOURCED=1
        alias gh="op plugin run -- gh"
        cat "${config.age.secrets.atuin.path}"
      '';
    };

    nix = {
      extraOptions = ''
        auto-optimise-store = true
        builders-use-substitutes = true
      '';

      distributedBuilds = true;

      buildMachines = [
        {
          hostName = "builder@blue-fire";
          systems = ["x86_64-linux" "i686-linux" "aarch64-linux"];
          maxJobs = 2;
          supportedFeatures = ["kvm" "benchmark" "big-parallel"];
          speedFactor = 50;
        }
        {
          hostName = "builder@enzian";
          systems = ["x86_64-linux" "i686-linux" "aarch64-linux"];
          maxJobs = 2;
          supportedFeatures = ["kvm" "benchmark" "big-parallel"];
          speedFactor = 10;
        }
        {
          hostName = "builder@wodan-wsl";
          systems = ["x86_64-linux" "i686-linux" "aarch64-linux"];
          maxJobs = 2;
          supportedFeatures = ["kvm" "benchmark" "big-parallel"];
          speedFactor = 100;
        }
      ];
    };
  };
}
