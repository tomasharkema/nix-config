{ pkgs
, inputs
, ...
}@attrs: {
  environment.systemPackages =
    import ../packages/common.nix attrs;
}
