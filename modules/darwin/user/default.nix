{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  # imports = [../../nixos/user];

  options.user = with types; {
    name = mkOption {
      type = types.str;
      default = "tomas";
      description = "The name to use for the user account.";
    };
  };

  config = {
    nix.distributedBuilds = true;
    # optional, useful when the builder has a faster internet connection than yours
    nix.extraOptions = ''
      builders-use-substitutes = true
    '';

    nix.settings = {
      extra-experimental-features = "nix-command flakes";
      # distributedBuilds = true;
      trusted-users = ["root" "tomas"];
      extra-substituters = [
        "https://nix-cache.harke.ma/tomas"
        "https://cache.nixos.org/"
      ];
      extra-binary-caches = [
        "https://nix-cache.harke.ma/tomas"
        "https://cache.nixos.org/"
      ];
      extra-trusted-public-keys = [
        "nix-cache.harke.ma:2UhS18Tt0delyOEULLKLQ36uNX3/hpX4sH684B+cG3c="
      ];
      access-tokens = ["github.com=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"];
    };
  };
}
