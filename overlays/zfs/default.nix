{...}: final: prev: {
  zfs = prev.zfs.overrideAttrs (_: {
    meta.platforms = [];
  });
}
