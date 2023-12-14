{
  nixConfig = {
    extra-experimental-features = "nix-command flakes";
    distributedBuilds = true;
    builders-use-substitutes = true;
    trusted-users = [ "root" "tomas" ];
    trusted-substituters = [
      "https://nix-cache.harke.ma/"
      "https://tomasharkema.cachix.org/"
      "https://cache.nixos.org/"
    ];
    trusted-binary-caches = [
      "https://nix-cache.harke.ma/"
      "https://tomasharkema.cachix.org/"
      "https://cache.nixos.org/"
    ];
    trusted-public-keys = [
      "nix-cache.harke.ma:2UhS18Tt0delyOEULLKLQ36uNX3/hpX4sH684B+cG3c="
      "tomasharkema.cachix.org-1:LOeGvH7jlA3vZmW9+gHyw0BDd1C8a0xrQSl9WHHTRuA="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    access-tokens = [ "github.com=***REMOVED***" ];
  };
}
