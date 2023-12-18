{
  nixConfig = {
    extra-experimental-features = "nix-command flakes";
    distributedBuilds = true;
    builders-use-substitutes = true;
    trusted-users = [ "root" "tomas" ];
    trusted-substituters = [
      "https://nix-cache.harke.ma/tomas"
      "https://cache.nixos.org"
    ];
    trusted-binary-caches = [
      "https://nix-cache.harke.ma/tomas"
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "nix-cache.harke.ma:2UhS18Tt0delyOEULLKLQ36uNX3/hpX4sH684B+cG3c="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    access-tokens = [ "github.com=***REMOVED***" ];
  };
}
