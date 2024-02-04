{channels, ...}: final: prev: {
  go = channels.unstable.go;
  buildGoModule = channels.unstable.buildGoModule;
}
