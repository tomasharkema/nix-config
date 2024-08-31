{ ... }: [
  # {
  #   hostName = "localhost";
  #   systems = ["x86_64-linux" "aarch64-linux" "i686-linux"];
  #   supportedFeatures = ["kvm" "nixos-test" "big-parallel" "benchmark"];
  #   maxJobs = 2;
  # }
  # {
  #   hostName = "builder@wodan-wsl";
  #   systems = ["x86_64-linux" "aarch64-linux" "i686-linux"];
  #   supportedFeatures = ["kvm" "nixos-test" "big-parallel" "benchmark"];
  #   maxJobs = 2;
  # }
  {
    hostName = "builder@wodan";
    systems = [ "x86_64-linux" "aarch64-linux" "i686-linux" ];
    supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" ];
    maxJobs = 2;
  }
  {
    hostName = "builder@enzian";
    systems = [ "x86_64-linux" "aarch64-linux" "i686-linux" ];
    supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" ];
    maxJobs = 2;
  }
  {
    hostName = "builder@arthur";
    systems = [ "x86_64-linux" "aarch64-linux" "i686-linux" ];
    supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" ];
    maxJobs = 2;
  }
]
