{
  pkgs,
  inputs,
  ...
}: {
  config = {
    # home.packages = import ./nixpkgs.nix {inherit pkgs inputs;};
  };
}
