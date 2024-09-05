{
  channels,
  disko,
  self,
  lib,
  inputs,
  ...
}: final: prev: rec {
  # unstable = channels.unstable;

  conky = inputs.conky.packages."${prev.system}".default.overrideAttrs {
    x11Support = true;
    waylandSupport = true;
    nvidiaSupport = true;
  };

  cachix = prev.cachix.overrideAttrs {meta.mainProgram = "cachix";};

  # buildbot = channels.unstable.buildbot;
  # python3 = prev.python312;:q
  # python3Packages = prev.python312Packages;

  # zerotierone = prev.zerotierone.overrideAttrs (drv: {
  #   postPatch = ''
  #     cp ${./Cargo.lock} Cargo.lock
  #     cp ./Cargo.lock ./rustybits/Cargo.lock
  #   '';

  #   cargoDeps = prev.rustPlatform.importCargoLock {
  #     lockFile = ./Cargo.lock;
  #     outputHashes = {
  #       "jwt-0.16.0" = "sha256-P5aJnNlcLe9sBtXZzfqHdRvxNfm6DPBcfcKOVeLZxcM=";
  #       "rustfsm-0.1.0" = "sha256-q7J9QgN67iuoNhQC8SDVzUkjCNRXGiNCkE8OsQc5+oI=";
  #     };
  #   };
  # });
}
