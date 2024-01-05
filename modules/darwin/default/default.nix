{pkgs, ...}: {
  config = {
    services.nix-daemon.enable = true;

    system.stateVersion = 4;

    nix = {
      extraOptions = ''
        auto-optimise-store = true
        builders-use-substitutes = true
      '';

      distributedBuilds = true;

      buildMachines = [
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
    };
  };
}
