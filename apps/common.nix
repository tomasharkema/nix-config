{ pkgs, inputs, ... }: {
  environment.systemPackages =
    import ../packages/common.nix { inherit pkgs inputs; };
}
