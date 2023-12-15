{ config, ... }: {
  config = {
    nixpkgs.hostPlatform = "x86_64-linux";
    # targets.genericLinux.enable = true;
  };
}
