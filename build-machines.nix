{...}: [
  # {
  #   hostName = "localhost";
  #   systems = ["x86_64-linux" "aarch64-linux" "i686-linux"];
  #   supportedFeatures = ["kvm" "nixos-test" "big-parallel" "benchmark"];
  #   maxJobs = 2;
  # }
  {
    hostName = "wodan-vm";
    systems = ["x86_64-linux" "aarch64-linux" "i686-linux"];
    supportedFeatures = ["kvm" "nixos-test" "big-parallel" "benchmark"];
    maxJobs = 2;
  }
  {
    hostName = "enzian";
    systems = ["x86_64-linux" "aarch64-linux" "i686-linux"];
    supportedFeatures = ["kvm" "nixos-test" "big-parallel" "benchmark"];
    maxJobs = 2;
  }
  {
    hostName = "arthur";
    systems = ["x86_64-linux" "aarch64-linux" "i686-linux"];
    supportedFeatures = ["kvm" "nixos-test" "big-parallel" "benchmark"];
    maxJobs = 2;
  }
]
