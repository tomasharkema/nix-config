{
  nil,
  devenv,
  ...
}: final: prev: {
  nil = nil.packages.${prev.system}.default;
  devenv = devenv.packages.${prev.system}.default;
}
