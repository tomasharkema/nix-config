{
  distributedBuilds = true;
  settings = {
    use-cgroups = true;
    extra-experimental-features = "nix-command flakes cgroups";

    builders-use-substitutes = true;
    trusted-users = ["root" "tomas"];

    # netrc-file = "/etc/nix/netrc";

    # trustedBinaryCaches = ["https://cache.nixos.org"];
    # binaryCaches = ["https://cache.nixos.org"];

    substituters = [
      "https://cache.nixos.org/"
      "https://nix-gaming.cachix.org"
      "https://nix-community.cachix.org"
      "https://nix-cache.harke.ma/tomas/"
      "https://devenv.cachix.org"
      "https://cuda-maintainers.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "peerix-tomas-1:OBFTUNI1LIezxoFStcRyCHKi2PHExoIcZA0Mfq/4uJA="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "tomas:hER/5A08v05jH8GnQUZRrh33+HDNbeiJj8z/8JY6ZvI="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };
}
