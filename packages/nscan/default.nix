{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with pkgs;
  buildGoModule rec {
    pname = "nscan";
    version = "0.5.1";

    src = fetchTarball {
      url = "https://git.sr.ht/~youkai/nscan/archive/v${version}.tar.gz";
      sha256 = "sha256:1m8zrqggxvk3s1xlrcj9a6jlgnj56zzg28ijk9jm4z34kv9kx8xx";
    };

    vendorHash = null;
  }
