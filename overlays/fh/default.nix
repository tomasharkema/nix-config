{fh, ...}: final: prev: {
  fh = fh.packages.${prev.system}.default;
}
