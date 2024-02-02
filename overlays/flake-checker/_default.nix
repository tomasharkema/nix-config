{
  # flake-checker,
  ...
}: final: prev: {
  # flake-checker = flake-checker.packages.${prev.system}.default;
}
