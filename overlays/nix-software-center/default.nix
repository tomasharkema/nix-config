{nix-software-center, ...}: final: prev: {
  nix-software-center = nix-software-center.packages.${prev.system}.nix-software-center;
}
