{
  nil,
  devenv,
  deploy-rs,
  attic,
  agenix,
  hydra-check,
  flake-checker,
  channels,
  ...
}: final: prev: {
  nil = nil.packages."${prev.system}".default;
  devenv = devenv.packages."${prev.system}".default;
  deploy-rs = deploy-rs.packages."${prev.system}".default;
  attic = attic.packages."${prev.system}".default;
  agenix = agenix.packages."${prev.system}".default;
  hydra-check = hydra-check.packages."${prev.system}".default;
  flake-checker = flake-checker.packages."${prev.system}".default;
  nixUnstable = channels.unstable.nixVersions.nix_2_21;
}
