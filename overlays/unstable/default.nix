{
  channels,
  disko,
  self,
  lib,
  inputs,
  ...
}: (final: prev: rec {
  # unstable = channels.unstable;

  # conky = prev.conky.override {
  #   x11Support = true;
  #   waylandSupport = true;
  #   nvidiaSupport = true;
  # };
  plex = prev.plex.overrideAttrs (old: {
    pname = "plex";
    version = "1.42.2.10156";
  });

  resilio-sync = prev.resilio-sync.overrideAttrs (old: rec {
    pname = "resilio-sync";
    version = "3.1.1.1075";

    src =
      {
        x86_64-linux = prev.fetchurl {
          url = "https://download-cdn.resilio.com/${version}/linux/x64/0/resilio-sync_x64.tar.gz";
          hash = "sha256-FgRMK5dOxkbaXyi0BPYQZK0tR/ZZuuUGAciwThqICBk=";
        };

        aarch64-linux = prev.fetchurl {
          url = "https://download-cdn.resilio.com/${version}/linux/arm64/0/resilio-sync_arm64.tar.gz";
          hash = "sha256-iczg1jEy+49QczKxc0/UZJ8LPaCHsXKmSrudVb3RWZ8=";
        };
      }
    .${
        prev.stdenv.hostPlatform.system
      } or (throw "Unsupported system: ${prev.stdenv.hostPlatform.system}");
  });

  usbguard = prev.usbguard.overrideAttrs {meta.mainProgram = "usbguard";};

  # _gpsd = prev.gpsd.overrideAttrs (old: rec {
  #   pname = "gpsd";
  #   version = "3.26.1";

  #   src = prev.fetchurl {
  #     url = "mirror://savannah/${pname}/${pname}-${version}.tar.gz";
  #     sha256 = "sha256-3H5GWWjBVA5hvFfHWG1qV6AEchKgFO/a00j5B7wuCZA=";
  #   };

  #   patches = [
  #     (prev.fetchpatch {
  #       url = "https://raw.githubusercontent.com/NixOS/nixpkgs/refs/heads/nixos-25.05/pkgs/by-name/gp/gpsd/sconstruct-env-fixes.patch";
  #       hash = "sha256-VGdL4g+t/1W8mr3T1L/Mqu8E5vayczu/trhonU7guJQ=";
  #     })
  #   ];
  # });

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
})
