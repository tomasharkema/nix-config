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
        # {
        #   hostName = "blue-fire";
        #   systems = ["x86_64-linux" "i686-linux" "aarch64-linux"];
        #   maxJobs = 4;
        #   supportedFeatures = ["kvm" "benchmark" "big-parallel"];
        #   speedFactor = 100;
        # }
        # {
        #   hostName = "enzian";
        #   systems = ["x86_64-linux" "i686-linux" "aarch64-linux"];
        #   maxJobs = 4;
        #   supportedFeatures = ["kvm" "benchmark" "big-parallel"];
        #   speedFactor = 10;
        # }
        # {
        #   hostName = "wodan-wsl";
        #   system = "x86_64-linux";
        #   maxJobs = 4;
        #   supportedFeatures = ["kvm" "benchmark" "big-parallel"];
        #   speedFactor = 10;
        # }
        # {
        #   hostName = "wodan-wsl";
        #   system = "i686-linux";
        #   maxJobs = 4;
        #   supportedFeatures = ["kvm" "benchmark" "big-parallel"];
        #   speedFactor = 10;
        # }
        # {
        #   hostName = "wodan-wsl";
        #   system = "aarch64-linux";
        #   maxJobs = 4;
        #   supportedFeatures = ["kvm" "benchmark" "big-parallel"];
        #   speedFactor = 5;
        # }
      ];
    };
  };
}
