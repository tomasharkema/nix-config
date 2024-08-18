{
  channels,
  disko,
  self,
  lib,
  inputs,
  ...
}: final: prev: rec {
  unstable = channels.unstable;

  pnpm = channels.unstable.pnpm;

  nixd = channels.unstable.nixd;

  conky = inputs.conky.packages."${prev.system}".default.overrideAttrs {
    x11Support = false;
    waylandSupport = true;
    nvidiaSupport = true;
  };

  # buildbot = channels.unstable.buildbot;
  # python3 = prev.python312;:q
  # python3Packages = prev.python312Packages;

  # wezterm = channels.unstable.wezterm.overrideAttrs (drv: {
  #   cargoLock = {
  #     lockFile = ./Cargo.lock;
  #     allowBuiltinFetchGit = true;
  #     outputHashes = {
  #       # "xcb-imdkit-0.3.0" = "sha256-fTpJ6uNhjmCWv7dZqVgYuS2Uic36XNYTbqlaly5QBjI=";
  #     };
  #   };
  #   cargoDeps = drv.cargoDeps.overrideAttrs (lib.const {
  #     name = "${drv.pname}-${drv.version}-vendor";
  #     src = drv.src;
  #     outputHash = lib.fakeHash;
  #   });
  # });
}
