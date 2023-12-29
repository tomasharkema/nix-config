{pkgs, ...}: {
  config = {
    environment.systemPackages = with pkgs; [
      atuin
      custom.maclaunch
      kitty
      terminal-notifier
      custom.launchcontrol
      # vagrant
      # fig
    ];

    services.nix-daemon.enable = true;

    security.pam.enableSudoTouchIdAuth = true;

    system.stateVersion = 4;

    nix.buildMachines = [
      {
        hostName = "blue-fire";
        system = "x86_64-linux";
        maxJobs = 4;
        supportedFeatures = ["kvm" "benchmark" "big-parallel"];
        speedFactor = 7;
      }
      {
        hostName = "blue-fire";
        system = "i686-linux";
        maxJobs = 4;
        supportedFeatures = ["kvm" "benchmark" "big-parallel"];
        speedFactor = 7;
      }
      {
        hostName = "blue-fire";
        system = "aarch64-linux";
        maxJobs = 4;
        supportedFeatures = ["kvm" "benchmark" "big-parallel"];
        speedFactor = 5;
      }
      {
        hostName = "enzian";
        system = "x86_64-linux";
        maxJobs = 4;
        supportedFeatures = ["kvm" "benchmark" "big-parallel"];
        speedFactor = 10;
      }
      {
        hostName = "enzian";
        system = "i686-linux";
        maxJobs = 4;
        supportedFeatures = ["kvm" "benchmark" "big-parallel"];
        speedFactor = 10;
      }
      {
        hostName = "enzian";
        system = "aarch64-linux";
        maxJobs = 4;
        supportedFeatures = ["kvm" "benchmark" "big-parallel"];
        speedFactor = 5;
      }
      {
        hostName = "wodan-wsl";
        system = "x86_64-linux";
        maxJobs = 4;
        supportedFeatures = ["kvm" "benchmark" "big-parallel"];
        speedFactor = 10;
      }
      {
        hostName = "wodan-wsl";
        system = "i686-linux";
        maxJobs = 4;
        supportedFeatures = ["kvm" "benchmark" "big-parallel"];
        speedFactor = 10;
      }
      {
        hostName = "wodan-wsl";
        system = "aarch64-linux";
        maxJobs = 4;
        supportedFeatures = ["kvm" "benchmark" "big-parallel"];
        speedFactor = 5;
      }
    ];

    nix.extraOptions = ''
      auto-optimise-store = true
      builders-use-substitutes = true
    '';
  };
}
