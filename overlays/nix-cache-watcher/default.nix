{nix-cache-watcher, ...}: final: prev: {
  nix-cache-watcher = nix-cache-watcher.packages.${prev.system}.nix-cache-watcher;
}
