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
          systems = ["x86_64-linux" "i686-linux" "aarch64-linux"];
          maxJobs = 2;
          supportedFeatures = ["kvm" "benchmark" "big-parallel"];
          speedFactor = 50;
        }
        {
          hostName = "enzian";
          systems = ["x86_64-linux" "i686-linux" "aarch64-linux"];
          maxJobs = 2;
          supportedFeatures = ["kvm" "benchmark" "big-parallel"];
          speedFactor = 10;
        }
        {
          hostName = "wodan-wsl";
          systems = ["x86_64-linux" "i686-linux" "aarch64-linux"];
          maxJobs = 2;
          supportedFeatures = ["kvm" "benchmark" "big-parallel"];
          speedFactor = 100;
        }
      ];
    };
  };
}
