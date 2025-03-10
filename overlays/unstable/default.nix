{
  channels,
  disko,
  self,
  lib,
  inputs,
  ...
}: (final: prev: rec {
  # unstable = channels.unstable;

  conky = prev.conky.override {
    x11Support = true;
    waylandSupport = true;
    nvidiaSupport = true;
  };

  usbguard = prev.usbguard.overrideAttrs {meta.mainProgram = "usbguard";};

  # cachix = prev.cachix.overrideAttrs {meta.mainProgram = "cachix";};

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

  _ntopng = prev.ntopng.overrideAttrs (old: {
    version = "git+99588883";
    src = prev.fetchFromGitHub {
      owner = "ntop";
      repo = "ntopng";
      rev = "995888839d09242dce99a65a8979e536ac02eb18";
      hash = "sha256-HE/sLpHED1cOqD8Pc1Ui8fwh2Yc68nRJYfyBOTM86vQ=";
      fetchSubmodules = true;
    };
    preConfigure = ''
      substituteInPlace Makefile.in \
        --replace "/bin/rm" "rm" \
        --replace "cp -r ./httpdocs" "cp -LR ./httpdocs"
    '';
  });
})
