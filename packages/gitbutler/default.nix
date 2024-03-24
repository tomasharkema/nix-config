{
  appimageTools,
  fetchzip,
  fetchurl,
  lib,
}:
appimageTools.wrapType2 rec {
  # or wrapType1
  name = "gitbutler";
  version = "0.10.27-746";

  src = fetchurl {
    url = "https://releases.gitbutler.com/releases/release/${version}-746/linux/x86_64/git-butler_${(builtins.head (lib.strings.splitString "-" version))}_amd64.AppImage";
    hash = "sha256-J7y/KfT5EfxWks2OXYGJIkPex8yh4jdFBhyGKXTXKFA=";
  };
  extraPkgs = pkgs: with pkgs; [libthai];
}
