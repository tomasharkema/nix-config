{go-nixos-menu, ...}: final: prev: {
  go-nixos-menu = go-nixos-menu.packages.${prev.system}.default;
}
