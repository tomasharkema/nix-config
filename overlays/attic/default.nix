{attic, ...}: final: prev: {
  attic = attic.packages.${prev.system}.default;
}
