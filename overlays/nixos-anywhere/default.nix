{nixos-anywhere, ...}: final: prev: {
  nixos-anywhere = nixos-anywhere.packages.${prev.system}.nixos-anywhere;
}
