{
  nixConfig = {
    use-cgroups = true;
    extra-experimental-features = "nix-command flakes cgroups";
    distributedBuilds = true;
    builders-use-substitutes = true;
    trusted-users = ["root" "tomas"];

    substituters = [
      "https://nix-community.cachix.org"
      "https://cache.nixos.org/"
      "https://blue-fire.ling-lizard.ts.net/attic/"
    ];

    trusted-public-keys = [
      "tomas:eOMnjVopwTC6220eUnejgPyFkTUEyVj2EB8eWdJIR4s="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
